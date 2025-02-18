import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';
import 'package:yetanothershoppinglist/widgets/drawer.dart';

final double _cardElevation = 10.0;

class ListOverview extends StatelessWidget {
  final TextStyle completedItem =
      TextStyle(decoration: TextDecoration.lineThrough, fontSize: 20.0);
  final TextStyle defaultItem = TextStyle(fontSize: 20.0);
  final _newListForm = GlobalKey<FormState>();
  bool loadingNewList = false;
  final TextStyle _titleStyle = TextStyle(
    fontSize: 36,
  );
  final TextStyle _itemStyle = TextStyle(fontSize: 20);
  final TextStyle _completeItem = TextStyle(
    fontSize: 20,
    decoration: TextDecoration.lineThrough,
  );

  Widget _buildListOverview(
      BuildContext context, ShoppingListEntity list, ListsLoaded state) {
    return SizedBox(
      height: 250,
      child: Material(
        child: Dismissible(
          key: ValueKey(list),
          onDismissed: (direction) {
            BlocProvider.of<ShoppingListBloc>(context)
                .add(DeleteList(list, state.lists));
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('List ${list.title} dismissed'),
            ));
          },
          child: InkWell(
            onTap: () {
              print('picked list with id ${list.id}');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListViewer(list.id);
              }));
            },
            child: Card(
              elevation: _cardElevation,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        list.title,
                        style: _titleStyle,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Container(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 0.0),
                            colors: [Colors.blue, Colors.black12],
                          ),
                        ),
                      ),
                      //Spacer(),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 150,
                        ),
                        child: list.collection.length != 0
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: list.collection.length,
                                itemBuilder: (context, idx) {
                                  return Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 16,
                                          child: Icon(list
                                                  .collection[idx].complete
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank),
                                        ),
                                        Spacer(),
                                        Flexible(
                                          flex: 16,
                                          child: Text(

                                            list.collection[idx].title,
                                            overflow: TextOverflow.ellipsis,
                                            style: list.collection[idx].complete
                                                ? _completeItem
                                                : _itemStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Opacity(
                                opacity: 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.filter_none, size: 42),
                                    Divider(),
                                    Text('This list is empty',
                                        style: TextStyle(fontSize: 24.0)),
                                  ],
                                ),
                              ),
                      ),
                      Expanded(
                          child: Stack(
                        children: <Widget>[
                          Container(
                            foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.white],
                            )),
                          ),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListCards(BuildContext context, ListsLoaded state) {
    List<ShoppingListEntity> lists = state.lists;
    return state.lists.length == 0
        ? Opacity(
            opacity: 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.insert_comment, size: 42),
                Divider(),
                Text('No lists found, create one now',
                    style: TextStyle(fontSize: 24.0)),
              ],
            ),
          )
        : CustomScrollView(
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
                  (context, idx) =>
                      _buildListOverview(context, state.lists[idx], state),
                  childCount: state.lists.length,
                ),
              )
            ],
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
        title: Text('Start a new list'),
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
