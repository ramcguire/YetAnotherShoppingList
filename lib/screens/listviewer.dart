import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

class ListViewer extends StatelessWidget {
  final String listId;
  final TextStyle completedItem =
  TextStyle(decoration: TextDecoration.lineThrough);

  ListViewer(this.listId);

  Widget mainBody(BuildContext context, ShoppingListEntity selectedList) {
    return Scaffold(
        appBar: AppBar(
          title: Text(selectedList.title),
        ),
        body: Material(
//          child: Column(
//            children: tileList(context, selectedList),
//          ),
            child: ListView(
              children: tileList(context, selectedList),
            )));
  }

  void updateCheckbox(BuildContext context, ShoppingListEntity list,
      ShoppingListItem item) {
    item.complete = !item.complete;
    BlocProvider.of<ShoppingListBloc>(context).add(UpdateList(list, "data"));
  }

  List<Widget> tileList(BuildContext context, ShoppingListEntity selectedList) {
    return selectedList.collection.map((item) {
      return EditableTile(selectedList, item);
    }).toList();
  }

  Widget checkboxTile(BuildContext context, ShoppingListItem item,
      ShoppingListEntity list) {
    return InkWell(
      child: CheckboxListTile(
        title: Text(item.title),
        value: item.complete,
        subtitle: Text(item.description),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          item.complete = !item.complete;
          BlocProvider.of<ShoppingListBloc>(context)
              .add(UpdateList(list, "data"));
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

  @override
  Widget build(BuildContext context) {
    //return mainBody(context);
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          ShoppingListEntity selectedList =
          state.lists.firstWhere((list) => list.id == this.listId);
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
            )
        ),
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
        title: Text(item.title),
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
//            decoration: InputDecoration(
//              labelText: 'Entry name',
//            ),
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
