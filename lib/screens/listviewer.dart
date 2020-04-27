import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/add_edit.dart';
import 'package:yetanothershoppinglist/widgets/item_tile.dart';
import 'package:yetanothershoppinglist/widgets/share.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:email_validator/email_validator.dart';

class ListViewer extends StatefulWidget {
  final String listId;

  ListViewer(this.listId);

  @override
  _ListViewerState createState() => _ListViewerState(listId);
}

class _ListViewerState extends State<ListViewer> {
  final _userForm = GlobalKey<FormState>();
  final _titleForm = GlobalKey<FormState>();
  final String listId;
  final TextStyle completedItem =
      TextStyle(decoration: TextDecoration.lineThrough);
  int _selectedIndex = 0;
  bool isEditing = false;
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _ListViewerState(this.listId);

  void onTabSelected(int idx) {
    setState(() {
      _selectedIndex = idx;
      pageController.animateToPage(idx,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  Widget editTitleDialog(
      BuildContext context, ShoppingListEntity selectedList) {
    return AlertDialog(
      title: Text('Edit title'),
      content: Form(
        key: _titleForm,
        child: TextFormField(
          autofocus: true,
          initialValue: selectedList.title,
          onSaved: (value) {
            BlocProvider.of<ShoppingListBloc>(context)
                .add(UpdateList(selectedList.copyWith(value), "data"));
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Title cannot be empty';
            }
            if (value == selectedList.title) {
              return 'New title must be different';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (_titleForm.currentState.validate()) {
              _titleForm.currentState.save();
              Navigator.of(context).pop();
            }
          },
          child: Text('Save title'),
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget addUserDialog(BuildContext context, ShoppingListEntity selectedList) {
    return AlertDialog(
        title: Text('Add a user'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_userForm.currentState.validate()) {
                _userForm.currentState.save();
                Navigator.of(context).pop();
              }
            },
            child: Text('Add User'),
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Form(
          key: _userForm,
          child: TextFormField(
            autofocus: true,
            onSaved: (value) {
              selectedList.authorized.add(value);
              BlocProvider.of<ShoppingListBloc>(context)
                  .add(UpdateList(selectedList, "data"));
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Email cannot be blank';
              }
              if (!EmailValidator.validate(value)) {
                return 'Enter a valid email address';
              }
              if (selectedList.authorized.contains(value)) {
                return 'User already has access';
              }
              return null;
            },
          ),
        ));
  }

  Widget mainBody(BuildContext context, ShoppingListEntity selectedList,
      ListsLoaded state) {
    List<Widget> tabs = List<Widget>();
    tabs.add(tileList(context, selectedList, state));
    tabs.add(
        ShareScreen(selectedList.id, addUserDialog(context, selectedList)));
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            if (_selectedIndex == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddEditScreen.add(selectedList);
              }));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: addUserDialog(context, selectedList));
            }
          },
        ),
        appBar: AppBar(
          title: Text(selectedList.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.title),
              tooltip: 'Edit list title',
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: editTitleDialog(context, selectedList));
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightGreenAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              title: Text('Share'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: onTabSelected,
        ),
        body: Material(
            child: PageView(
          onPageChanged: onTabSelected,
          controller: pageController,
          children: tabs,
        )));
  }

  void updateCheckbox(
      BuildContext context, ShoppingListEntity list, ShoppingListItem item) {
    item.complete = !item.complete;
    BlocProvider.of<ShoppingListBloc>(context).add(UpdateList(list, "data"));
  }

  Widget tileList(BuildContext context, ShoppingListEntity selectedList,
      ListsLoaded state) {
    return selectedList.collection.length != 0
        ? ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final ShoppingListItem item =
                  selectedList.collection.removeAt(oldIndex);
              selectedList.collection.insert(newIndex, item);
              BlocProvider.of<ShoppingListBloc>(context)
                  .add(UpdateListLocal(selectedList, state.lists, "data"));
            },
            children: selectedList.collection.map<Widget>((item) {
              return itemTile(context, item, selectedList, false);
            }).toList())
        : Opacity(
            opacity: 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.filter_none, size: 42),
                Divider(),
                Text('This list is empty', style: TextStyle(fontSize: 24.0)),
              ],
            ),
          );
  }

//      return AnimatedSwitcher(
//        duration: const Duration(milliseconds: 500),
//        transitionBuilder: (Widget child, Animation<double> animation) =>
//            SlideTransition(
//          position: animation.drive(Tween(
//            begin: Offset(0, 1),
//            end: Offset(0, 0),
//          )),
//          child: child,
//        ),
//        child: isEditing
//            ? editTile(context, item, selectedList)
//            : itemTile(context, item, selectedList),
//      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          ShoppingListEntity selectedList =
              state.lists.firstWhere((list) => list.id == this.widget.listId);
          return mainBody(context, selectedList, state);
        }

        Navigator.of(context).pop();
        return null;
      },
    );
  }
}
