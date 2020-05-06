import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'widgets.dart';

class TileList extends StatelessWidget {
  final ShoppingListEntity selectedList;

  TileList(this.selectedList);

  @override
  Widget build(BuildContext context) {
    return selectedList.collection.length != 0
        ? ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final ShoppingListItem item =
          selectedList.collection.removeAt(oldIndex);
          selectedList.collection.insert(newIndex, item);
          BlocProvider.of<ShoppingListBloc>(context)
              .add(UpdateList(selectedList, "data"));
        },
        children: selectedList.collection.map<Widget>((item) {
          return ListItem(
              item: item,
              currentList: selectedList,
              key: ValueKey(item.uid));
        }).toList())
        : Opacity(
      opacity: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.filter_none, size: 42),
          Divider(),
          Text('This list is empty', style: TextStyle(fontSize: 24.0)),
        ],
      ),
    );
  }
}
