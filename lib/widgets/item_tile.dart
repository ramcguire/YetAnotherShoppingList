import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';

Widget itemTile(BuildContext context, ShoppingListItem item,
    ShoppingListEntity list, bool preview) {
  final double _fontSize = 20.0;
  final TextStyle completedItem =
      TextStyle(decoration: TextDecoration.lineThrough, fontSize: _fontSize);
  final TextStyle defaultItem = TextStyle(fontSize: _fontSize);
  final SlidableController controller = SlidableController();

  return preview
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(item.complete
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            Text('\t\t\t\t'),
            Text(
              item.title,
              style: item.complete ? completedItem : defaultItem,
            ),
          ],
        )
      : Slidable(
          controller: controller,
          key: ValueKey(item.uid),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          dismissal: SlidableDismissal(
            dragDismissible: false,
            child: SlidableDrawerDismissal(),
            onDismissed: (actionType) {
              list.collection.remove(item);
              BlocProvider.of<ShoppingListBloc>(context)
                  .add(UpdateList(list, "data"));
            },
          ),
          actions: <Widget>[
            IconSlideAction(
              icon: Icons.delete,
              color: Colors.red,
              caption: 'Delete',
              onTap: () {
                controller.activeState.dismiss();
              },
            ),
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
          ],
          child: item.description == ''
              ? CheckboxListTile(
                  title: Text(item.title,
                      style: item.complete ? completedItem : TextStyle()),
                  value: item.complete,
                  onChanged: (value) {
                    item.complete = !item.complete;
                    BlocProvider.of<ShoppingListBloc>(context)
                        .add(UpdateList(list, "data"));
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                )
              : CheckboxListTile(
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
