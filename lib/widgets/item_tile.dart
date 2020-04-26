import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';

Widget itemTile(BuildContext context, ShoppingListItem item,
    ShoppingListEntity list, bool preview) {

  final TextStyle completedItem =
      TextStyle(decoration: TextDecoration.lineThrough);

  return preview
      ? CheckboxListTile(
          title: Text(item.title,
              style: item.complete ? completedItem : TextStyle()),
          subtitle: Text(item.description),
          value: item.complete,
          onChanged: null,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
        )
      : Slidable(
          key: ValueKey(item.uid),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          actions: <Widget>[
            IconSlideAction(
              icon: Icons.edit,
              color: Colors.green,
              caption: 'Edit',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddEditScreen(list, item);
                }));
              },
            ),
            IconSlideAction(
              icon: Icons.delete,
              color: Colors.red,
              caption: 'Delete',
              onTap: () {
                list.collection.remove(item);
                BlocProvider.of<ShoppingListBloc>(context)
                    .add(UpdateList(list, "data"));
              },
            )
          ],
          child: CheckboxListTile(
            title: Text(item.title,
                style: item.complete ? completedItem : TextStyle()),
            subtitle: Text(item.description),
            value: item.complete,
            onChanged: (value) {
              item.complete = !item.complete;
              BlocProvider.of<ShoppingListBloc>(context)
                  .add(UpdateList(list, "data"));
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
}
