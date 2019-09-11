import 'package:course_gnome/state/scheduling/scheduling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:course_gnome/state/auth/auth.dart';
import 'package:course_gnome/ui/scheduling/scheduling.dart';
import 'package:course_gnome/ui/shared/colors.dart';

void main() {
  final UserRepository userRepository = UserRepository();
  final AuthRepository authRepository = AuthRepository(
    userRepository: userRepository,
  );
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  runApp(App(userRepository, authRepository, scheduleRepository));
}

class App extends StatefulWidget {
  App(
    this.userRepository,
    this.authRepository,
    this.scheduleRepository,
  );
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final ScheduleRepository scheduleRepository;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          builder: (_) => AuthBloc(
            authRepository: widget.authRepository,
          ),
        ),
        BlocProvider<ScheduleBloc>(
          builder: (_) => ScheduleBloc(
            scheduleRepository: widget.scheduleRepository,
            userRepository: widget.userRepository,
          ),
        )
      ],
      child: MaterialApp(
        theme: _buildTheme(),
        home: SchedulingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: cgRed,
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
              .apply(fontFamily: 'Merriweather')
              .copyWith(fontSize: 24.0, color: Color(0xff4D4D4D)),
        );
  }
}
