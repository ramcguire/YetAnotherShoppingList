import 'package:flutter/material.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // use BlocBuilder to conditionally build drawer header
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(state.user.displayName),
                    accountEmail: Text(state.user.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(state.user.photoUrl),
                    ),
                  );
                }
                return UserAccountsDrawerHeader(
                  accountName: Text('placeholder name'),
                  accountEmail: Text('placeholder email'),
                );
              }),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: () async {
              Navigator.pop(context);
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ));
}