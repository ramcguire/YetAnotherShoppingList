import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

class ShareScreen extends StatefulWidget {
  final ShoppingListEntity list;

  ShareScreen(this.list);

  @override
  _ShareScreenState createState() => _ShareScreenState(list);
}

class _ShareScreenState extends State<ShareScreen> {
  final ShoppingListEntity list;
  bool addingUser = false;


  _ShareScreenState(this.list);

  Widget _buildUserTile(BuildContext context, ShoppingListEntity list,
      String user, String currentUser) {
    if (list.owner == user) {
      return ListTile(
        title: Text(user),
        trailing: Icon(Icons.lock_outline),
      );
    }
    if (currentUser == list.owner) {
      return ListTile(
        title: Text(user),
        // convert to button
        trailing: Icon(Icons.remove),
      );
    }
    return ListTile(
      title: Text(user),
    );
  }

  Widget _addUserTile(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: addingUser ? Container() : _promptAddUser(context),
    );
  }

  Widget _promptAddUser(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.add),
      title: Text('Share this list'),
      onTap: () {
        setState(() {
          addingUser = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentUser = BlocProvider.of<ShoppingListBloc>(context).getUser();
    List<Widget> sharedWith = list.authorized.map((user) {
      return _buildUserTile(context, list, user, currentUser);
    }).toList();
    sharedWith.add(_promptAddUser(context));
    return ListView(
      children: sharedWith,
    );
//    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
//        builder: (context, state) {
//          if (state is ListsLoaded) {
//            ShoppingListEntity list = state.lists.firstWhere((list) =>
//            list.id == widget.listId);
//
//          }
//          return CircularProgressIndicator();
//        }
//    );
  }
}
