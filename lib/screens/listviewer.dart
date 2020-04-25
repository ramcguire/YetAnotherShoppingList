import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/widgets/share.dart';

class ListViewer extends StatefulWidget {
  final String listId;

  ListViewer(this.listId);

  @override
  _ListViewerState createState() => _ListViewerState(listId);
}

class _ListViewerState extends State<ListViewer> {
  final String listId;
  final TextStyle completedItem =
      TextStyle(decoration: TextDecoration.lineThrough);
  int _selectedIndex = 0;
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

  Widget mainBody(BuildContext context, ShoppingListEntity selectedList) {
    List<Widget> tabs = List<Widget>();
    tabs.add(ListView(
      children: tileList(context, selectedList),
    ));
    tabs.add(ShareScreen(selectedList));
    return Scaffold(
        appBar: AppBar(
          title: Text(selectedList.title),
        ),
        bottomNavigationBar: BottomNavigationBar(
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

  List<Widget> tileList(BuildContext context, ShoppingListEntity selectedList) {
    return selectedList.collection.map((item) {
      return EditableTile(selectedList, item);
    }).toList();
  }

  Widget checkboxTile(
      BuildContext context, ShoppingListItem item, ShoppingListEntity list) {
    return InkWell(
      child: CheckboxListTile(
        title: Text(
          item.title,
          style: item.complete ? completedItem : TextStyle(),
        ),
        value: item.complete,
        subtitle: Text(
          item.description,
          style: item.complete ? completedItem : TextStyle(),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          item.complete = !item.complete;
          BlocProvider.of<ShoppingListBloc>(context)
              .add(UpdateList(list, "data"));
          setState(() {});
        },
      ),
    );
  }

  DataTable dataTable(BuildContext context, ShoppingListEntity selectedList) {
    return DataTable(
      columns: [
        DataColumn(label: Text('c')),
        DataColumn(label: Text('entry')),
      ],
      rows: selectedList.collection.map((item) {
        return DataRow(cells: [
          DataCell(Checkbox(
            value: item.complete,
            onChanged: (value) {
              item.complete = !item.complete;
              BlocProvider.of<ShoppingListBloc>(context)
                  .add(UpdateList(selectedList, "data"));
            },
          )),
          DataCell(Text(
            item.title,
            style: item.complete ? completedItem : TextStyle(),
          )),
        ]);
      }).toList(),
    );
  }

  Widget normalTile(
      BuildContext context, ShoppingListItem item, ShoppingListEntity entity) {
    return ListTile(
      leading: Checkbox(
        value: item.complete,
        onChanged: (value) {
          item.complete = !item.complete;
          BlocProvider.of<ShoppingListBloc>(context)
              .add(UpdateList(entity, "data"));
        },
      ),
      title:
          Text(item.title, style: item.complete ? completedItem : TextStyle()),
      //subtitle: Text(item.description),
      onTap: () {
        item.complete = !item.complete;
        BlocProvider.of<ShoppingListBloc>(context)
            .add(UpdateList(entity, "data"));
      },
    );
  }

  Widget editTile(
      BuildContext context, ShoppingListItem item, ShoppingListEntity entity) {
    return ListTile(
      leading: Checkbox(
        value: item.complete,
        onChanged: (value) {
          item.complete = !item.complete;
          BlocProvider.of<ShoppingListBloc>(context)
              .add(UpdateList(entity, "data"));
        },
      ),
      title:
          Text(item.title, style: item.complete ? completedItem : TextStyle()),
      subtitle: Text(item.description),
      trailing: Icon(Icons.edit),
      onTap: () {
        item.complete = !item.complete;
        BlocProvider.of<ShoppingListBloc>(context)
            .add(UpdateList(entity, "data"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //return mainBody(context);
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          ShoppingListEntity selectedList =
              state.lists.firstWhere((list) => list.id == this.widget.listId);
          return mainBody(context, selectedList);
        }

        return Container();
      },
    );
  }
}

class EditableTile extends StatefulWidget {
  final ShoppingListEntity list;
  final ShoppingListItem item;

  EditableTile(this.list, this.item);

  @override
  _EditableTileState createState() => _EditableTileState(list, item);
}

class _EditableTileState extends State<EditableTile> {
  final TextStyle completedItem =
      TextStyle(decoration: TextDecoration.lineThrough);
  final ShoppingListEntity list;
  final ShoppingListItem item;
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  final double itemSize = 70;

  _EditableTileState(this.list, this.item);

  Widget notEditing() {
    if (item.title == '') {
      return SizedBox(
        key: ValueKey<bool>(isEditing),
        height: itemSize,
        child: ListTile(
            leading: IconButton(
          icon: Icon(Icons.add),
          //onPressed:,
        )),
      );
    }
    return SizedBox(
      height: itemSize,
      child: ListTile(
        leading: Checkbox(
          value: item.complete,
          onChanged: (value) {
            item.complete = !item.complete;
            BlocProvider.of<ShoppingListBloc>(context)
                .add(UpdateList(list, "data"));
          },
        ),
        title: Text(item.title,
            style: item.complete ? completedItem : TextStyle()),
        //subtitle: Text(item.description),
        onTap: () {
          setState(() {
            isEditing = true;
          });
        },
      ),
    );
  }

  void submitForm() {
    FormState form = _formKey.currentState;
    if (form.validate()) {
      FocusScope.of(context).unfocus();
      form.save();
      BlocProvider.of<ShoppingListBloc>(context).add(UpdateList(list, "data"));
      setState(() {
        isEditing = false;
      });
    }
  }

  Widget editingTile2() {
    return SizedBox(
      key: ValueKey<bool>(isEditing),
      height: itemSize,
      child: ListTile(
        title: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: item.title,
            onSaved: (value) {
              setState(() {
                item.title = value;
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Entry cannot be empty.';
              }
              return null;
            },
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            print('submitting form');
            submitForm();
          },
        ),
      ),
    );
  }

  Widget editingTile() {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: item.title,
              decoration: InputDecoration(
                labelText: 'Entry name',
              ),
              onSaved: (value) {
                setState(() {
                  item.title = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Entry must cannot be empty.';
                }
                return null;
              },
            ),
            TextFormField(
                initialValue: item.description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  setState(() {
                    item.description = value != null ? value : '';
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => submitForm(),
                  child: Text('Save'),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  child: Text('Cancel'),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      child: isEditing ? editingTile2() : notEditing(),
    );
  }
}
