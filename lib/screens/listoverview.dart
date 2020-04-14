import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

class ListOverview extends StatelessWidget {
  final List<ShoppingListEntity> lists;

  ListOverview(this.lists);

  Widget _buildListOverview(BuildContext context, ShoppingListEntity list) {
    List<Widget> overview = List<Widget>();
    overview.add(Text(list.title));
    overview.add(Spacer());
    list.collection.forEach((item) {
      overview.add(Text(item.title));
    });
    return Column(
      children: overview,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lists.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, idx) {
        return Center(
            child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Card(
              color: Colors.blue,
              child: _buildListOverview(context, lists[idx]),
        )));
      },
    );
  }
}
