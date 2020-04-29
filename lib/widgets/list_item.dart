import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/add_edit.dart';

class ListItem extends StatelessWidget {
  final ShoppingListItem item;
  final ShoppingListEntity currentList;
  final SlidableController controller = SlidableController();
  final TextStyle _default = TextStyle(fontSize: 20);
  final TextStyle _complete = TextStyle(
    fontSize: 20,
    decoration: TextDecoration.lineThrough,
  );

  ListItem({
    Key key,
    @required this.item,
    @required this.currentList,
  }) : super(key: key);

  void onCheckboxChanged(BuildContext context) {
    ShoppingListEntity list =
        currentList.updateInPlace(item.copyWith(complete: !item.complete));
    BlocProvider.of<ShoppingListBloc>(context).add(UpdateList(list, "data"));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      key: ValueKey(item.uid),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      dismissal: SlidableDismissal(
        dragDismissible: false,
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          currentList.collection.remove(item);
          BlocProvider.of<ShoppingListBloc>(context)
              .add(UpdateList(currentList, "data"));
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
              return AddEditScreen(currentList, item);
            }));
          },
        ),
      ],
      child: item.description == ''
          ? CheckboxListTile(
              title: Text(item.title,
                  style: item.complete ? _complete : TextStyle()),
              value: item.complete,
              onChanged: (value) {
                onCheckboxChanged(context);
              },
              controlAffinity: ListTileControlAffinity.leading,
            )
          : CheckboxListTile(
              title:
                  Text(item.title, style: item.complete ? _complete : _default),
              subtitle: Text(item.description),
              value: item.complete,
              onChanged: (value) {
                onCheckboxChanged(context);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
    );
  }
}
