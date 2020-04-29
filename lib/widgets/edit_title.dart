import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:email_validator/email_validator.dart';

class EditTitle extends StatelessWidget {
  final ShoppingListEntity currentList;
  final _formKey = GlobalKey<FormState>();

  EditTitle(this.currentList);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit title'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          initialValue: currentList.title,
          onSaved: (value) {
            BlocProvider.of<ShoppingListBloc>(context)
                .add(UpdateList(currentList.copyWith(title: value), "data"));
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Title cannot be empty';
            }
            if (value == currentList.title) {
              return 'New title must be different';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
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
}
