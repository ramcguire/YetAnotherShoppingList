import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository _userRepository = UserRepository();
  final ShoppingListRepository _listRepository =
      ShoppingListRepository(Firestore.instance);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)
          ..add(AppStarted())),
    BlocProvider(
        create: (context) => ShoppingListBloc(listRepository: _listRepository))
  ], child: App(userRepository: _userRepository)));
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
      if (state is Unauthenticated) {
        return LoginScreen(userRepository: _userRepository);
      }
      if (state is Authenticated) {
        return Landing(user: state.user.email);
      }
      return SplashScreen();
    }));
  }
}
