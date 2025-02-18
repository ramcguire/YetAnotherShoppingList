import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';

class AddEditItem extends StatelessWidget {
  final ShoppingListEntity list;
  final bool adding;
  final _formKey = GlobalKey<FormState>();
  final ShoppingListItem item;
  String _description;
  String _title;

  AddEditItem(this.list, this.item) : adding = false;

  AddEditItem.add(this.list)
      : item = ShoppingListItem.createNew(),
        adding = true;

  void handleSave(BuildContext context, ShoppingListEntity currentList, List<ShoppingListEntity> lists) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (adding) {
        item.description = _description;
        item.title = _title;
        currentList.collection.add(item);
      }
      // prevent unnecessary writes
      else if (item.description != _description || item.title != _title) {
        ShoppingListItem currentItem = currentList.collection.firstWhere((
            i) => i.uid == item.uid);
        currentItem.description = _description;
        currentItem.title = _title;
      }
      BlocProvider.of<ShoppingListBloc>(context).add(UpdateList(currentList, "data"));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          List<ShoppingListEntity> lists = state.lists;
          ShoppingListEntity currentList = lists.firstWhere((i) =>
          i.id == list.id);
          if (!adding &&
              !currentList.collection.any((i) => i.uid == item.uid)) {
            Navigator.of(context).pop();
            return null;
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                handleSave(context, currentList, lists);
              },
            ),
            appBar: AppBar(
              title: Text(adding ? 'Add item' : 'Edit item'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Divider(),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => handleSave(context, currentList, lists),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: item.title,
                      onSaved: (value) {
                        _title = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Item',
                        icon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Item cannot be empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: item.description,
                      maxLines: 10,
                      onSaved: (value) {
                        _description = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                        icon: Icon(Icons.description),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        Navigator.of(context).pop();
        return null;
      },
    );
  }
}
