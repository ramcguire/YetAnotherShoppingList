import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/widgets/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import './screens.dart';

class Landing extends StatelessWidget {
  final String name;
  final ShoppingListRepository _shoppingListRepository;

  Landing({Key key, @required this.name})
      : _shoppingListRepository =
            ShoppingListRepository(Firestore.instance, name),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            ShoppingListBloc(listRepository: _shoppingListRepository)
              ..add(LoadLists()),
        child: Scaffold(
            drawer: buildDrawer(context),
            appBar: AppBar(
              title: Text('Home'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      LoggedOut(),
                    );
                  },
                )
              ],
            ),
            body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                builder: (context, state) {
              if (state is ListsLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is ListsLoaded) {
                return ListOverview(state.lists);
              }

              return Container();
            })));
  }
}
