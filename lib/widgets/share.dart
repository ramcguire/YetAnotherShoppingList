import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShareScreen extends StatelessWidget {
  final String listId;
  final Widget userPrompt;


  ShareScreen(this.listId, this.userPrompt);

  Widget _buildUserTile(BuildContext context, ShoppingListEntity list,
      String user, String currentUser, ListsLoaded state) {
    if (list.owner == user) {
      return ListTile(
        title: Text(user),
        subtitle: Text('Owner'),
        trailing: Icon(Icons.lock_outline),
      );
    }
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      actions: <Widget>[
        IconSlideAction(
          icon: Icons.clear,
          caption: 'Remove',
          color: Colors.red,
          onTap: () {
            list.authorized.remove(user);
            BlocProvider.of<ShoppingListBloc>(context).add(UpdateList(list, "data"));
          },
        )
      ],
      child: ListTile(
        title: Text(user),
        trailing: Icon(Icons.remove),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
      if (state is ListsLoaded) {
        ShoppingListEntity list =
            state.lists.firstWhere((list) => list.id == listId);
        String currentUser =
            BlocProvider.of<ShoppingListBloc>(context).getUser();
        return ListView(
          children: list.authorized.map((user) {
            return _buildUserTile(context, list, user, currentUser, state);
          }).toList(),
        );
      }
      return CircularProgressIndicator();
    });
  }
}
