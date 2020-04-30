import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';
import 'package:yetanothershoppinglist/widgets/widgets.dart';

class ListViewer extends StatefulWidget {
  final String listId;

  ListViewer(this.listId);

  @override
  _ListViewerState createState() => _ListViewerState(listId);
}

class _ListViewerState extends State<ListViewer> {
  final String listId;
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _ListViewerState(this.listId);

  int _selectedIdx = 0;

  void onTabSelected(int idx) {
    setState(() {
      pageController.animateToPage(idx,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
      _selectedIdx = idx;
    });
  }

  Widget mainBody(BuildContext context, ShoppingListEntity selectedList) {
    List<Widget> tabs = List<Widget>();
    tabs.add(tileList(context, selectedList));
    tabs.add(ShareScreen(selectedList.id, AddUser(selectedList)));
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            if (_selectedIdx == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddEditScreen.add(selectedList);
              }));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: AddUser(selectedList));
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
                    child: EditTitle(selectedList));
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
          currentIndex: _selectedIdx,
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

  Widget tileList(BuildContext context, ShoppingListEntity selectedList) {
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
                  .add(UpdateList(selectedList, "data"));
            },
            children: selectedList.collection.map<Widget>((item) {
              return ListItem(
                  item: item,
                  currentList: selectedList,
                  key: ValueKey(item.uid));
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      condition: (previousState, state) {
        if (previousState is ListsLoaded && state is ListsLoaded) {
          ShoppingListEntity prevList =
              previousState.lists.firstWhere((i) => i.id == this.widget.listId);
          ShoppingListEntity curList =
              state.lists.firstWhere((i) => i.id == this.widget.listId);
          return !(prevList.collection == curList.collection);
        }
        return true;
      },
      builder: (context, state) {
        if (state is ListsLoaded) {
          ShoppingListEntity selectedList =
              state.lists.firstWhere((list) => list.id == this.widget.listId);
          return mainBody(context, selectedList);
        }

        Navigator.of(context).pop();
        return Container();
      },
    );
  }
}
