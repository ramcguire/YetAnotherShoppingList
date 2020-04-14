import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;


  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  void _handleSignIn(AuthenticationBloc auth) {
   _userRepository.signInWithGoogle().then((user) {
    if (user != null) {
      auth.add(LoggedIn());
    }
   });
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc _auth = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Log in to Yet Another Shopping List'),
      ),
      body:
      Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
            RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              icon: Icon(FontAwesomeIcons.google, color: Colors.white),
              onPressed: () {
                _handleSignIn(_auth);
              },
              label: Text('Sign in with Google',
                  style: TextStyle(color: Colors.white)),
              color: Colors.redAccent,
            )
          ])),
    );
  }
}
