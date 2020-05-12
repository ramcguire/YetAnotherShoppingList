import 'package:flutter/material.dart';

class CreateList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Create new list',
                style: TextStyle(fontSize: 24.0),
              ),
              Expanded(child: SizedBox()),
              Icon(Icons.create),
            ],
          ),
          Divider(),
          Flexible(
            flex: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('add users')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('add categories')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
