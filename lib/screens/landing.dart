import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/widgets/shared.dart';
import './screens.dart';

class Landing extends StatelessWidget {
  final String user;

  Landing({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShoppingListBloc>(context).setUser(user);
    BlocProvider.of<ShoppingListBloc>(context).add(LoadLists());
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
      if (state is ListsLoading) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state is ListsLoaded) {
        return ListOverview();
      }

      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
