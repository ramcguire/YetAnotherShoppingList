import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

class AddEditScreen extends StatelessWidget {
  final ShoppingListEntity list;
  final bool adding;
  final _formKey = GlobalKey<FormState>();
  final ShoppingListItem item;

  AddEditScreen(this.list, this.item) : adding = false;

  AddEditScreen.add(this.list)
      : item = ShoppingListItem.createNew(),
        adding = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(adding ? 'Add item' : 'Edit item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: item.title,
              onSaved: (value) {
                item.title  = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter an item',
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
              initialValue: item.title,
              onSaved: (value) {
                item.description = value;
              },
              decoration: InputDecoration(
                labelText: 'Description for item',
                icon: Icon(Icons.description),
              ),
            )
          ],
        ),
      ),
    );
  }
}
