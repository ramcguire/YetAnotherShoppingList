import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';
import 'package:yetanothershoppinglist/widgets/drawer.dart';

final double _cardElevation = 10.0; // for ease of "tweaking", remove later

class ListOverview extends StatelessWidget {
  final _newListForm = GlobalKey<FormState>();
  bool loadingNewList = false;

  Widget _listItemSummary(BuildContext context, ShoppingListEntity list) {}

  Widget _buildListOverview(BuildContext context, ShoppingListEntity list) {
//    List<Widget> overview = List<Widget>();
//    overview.add(Text(list.title));
//    //overview.add(Spacer());
//    list.collection.forEach((item) {
//      overview.add(Text(item.title));
//    });
    return SizedBox(
      height: 400,
      child: Material(
        child: InkWell(
          onTap: () {
            print('picked list with id ${list.id}');
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListViewer(list.id);
            }));
          },
          child: Card(
            elevation: _cardElevation,
            child: Column(
              children: <Widget>[
                Text(list.title),
                Divider(),
                Text(
                  multiLineString(list),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String multiLineString(ShoppingListEntity list) {
    StringBuffer sb = StringBuffer();
    list.collection.forEach((item) {
      sb.write(item.title + '\n');
    });
    return sb.toString();
  }

  Widget _buildListCards(BuildContext context, ListsLoaded state) {
    List<ShoppingListEntity> lists = state.lists;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('ListOverview'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedOut(),
                );
              },
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, idx) => _buildListOverview(context, state.lists[idx]),
            childCount: state.lists.length,
          ),
        )
      ],
    );

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: state.lists.length,
      itemBuilder: (BuildContext context, int idx) {
        return _buildListOverview(context, lists[idx]);
      },
    );
  }

  void createNewList(BuildContext context, String listTitle) {
    loadingNewList = true;
    ShoppingListBloc bloc = BlocProvider.of<ShoppingListBloc>(context);
    bloc.getRepository().createNewShoppingList(listTitle, bloc.getUser()).then(
        (_) => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListViewer(_);
            })));
  }

  Widget newListForm(BuildContext context) {
    return AlertDialog(
        title: Text('Add a user'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_newListForm.currentState.validate()) {
                Navigator.of(context).pop();
                _newListForm.currentState.save();
              }
            },
            child: Text('Create new list'),
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Form(
          key: _newListForm,
          child: TextFormField(
            autofocus: true,
            onSaved: (value) {
              createNewList(context, value);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'List title cannot be blank';
              }
              return null;
            },
          ),
        ));
  }

  FloatingActionButton createListButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed: () {
        showDialog(context: context, child: newListForm(context));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: createListButton(context),
        drawer: buildDrawer(context),
        body: loadingNewList
            ? SpinKitCubeGrid(
                size: 150.0,
                color: Colors.blue,
              )
            : BlocBuilder<ShoppingListBloc, ShoppingListState>(
                builder: (context, state) {
                  if (state is ListsLoaded) {
                    return _buildListCards(context, state);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ));
  }
}
