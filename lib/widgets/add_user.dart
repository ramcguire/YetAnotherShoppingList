import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:email_validator/email_validator.dart';


class AddUser extends StatelessWidget {
  final ShoppingListEntity currentList;
  final _formKey = GlobalKey<FormState>();

  AddUser(this.currentList);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Add a user'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
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
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            onSaved: (value) {
              currentList.authorized.add(value);
              BlocProvider.of<ShoppingListBloc>(context)
                  .add(UpdateList(currentList, "data"));
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Email cannot be blank';
              }
              if (!EmailValidator.validate(value)) {
                return 'Enter a valid email address';
              }
              if (currentList.authorized.contains(value)) {
                return 'User already has access';
              }
              return null;
            },
          ),
        ));
  }
}
