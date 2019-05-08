import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core.dart';

import 'utils/auth.dart';
import 'ui/login/login_page.dart';

void main() {
  final UserRepository userRepository = UserRepository(
    getStoredAuth: getStoredAuth,
    storeAuth: storeAuth,
  );
  final AuthRepository authRepository = AuthRepository(
    userRepository: userRepository,
  );
  runApp(App(userRepository, authRepository));
}

class App extends StatefulWidget {
  App(this.userRepository, this.authRepository);
  final AuthRepository authRepository;
  final UserRepository userRepository;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: widget.authRepository);
    // _authBloc.dispatch(Init());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authBloc,
      child: MaterialApp(
        theme: _buildTheme(),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: Color(cgRed.asInt),
      textTheme: _buildTextTheme(base.textTheme),
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base
        .apply(
          fontFamily: 'Lato',
          bodyColor: Color(0xff4D4D4D),
        )
        .copyWith(
          button: base.button.copyWith(fontSize: 16),
          body1: base.body1.copyWith(fontSize: 16),
          display1: base.display1
              .apply(
                fontFamily: 'Merriweather',
              )
              .copyWith(
                fontSize: 24.0,
                color: Color(0xff4D4D4D),
              ),
        );
  }
}
