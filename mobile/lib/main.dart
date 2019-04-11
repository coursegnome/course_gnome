import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core.dart';

import 'package:course_gnome_mobile/utils/auth.dart';
import 'package:course_gnome_mobile/ui/LoginPage.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: _authBloc,
        child:
    MaterialApp(
      theme: ThemeData(
        primaryColor: Color(cgRed.toInt),
        fontFamily: 'Lato',
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    ),);
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }
}
