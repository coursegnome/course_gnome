import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => LoggedOut();

  @override
  Stream<AuthState> mapEventToState(
    AuthState currentState,
    AuthEvent event,
  ) async* {
    if (event is LogIn) {
      yield LoggedIn(user: event.user);
    } else {
      yield LoggedOut();
    }
  }
}

abstract class AuthState {}

class LoggedIn extends AuthState {
  LoggedIn({this.user});
  final User user;
}

class LoggedOut extends AuthState {}

abstract class AuthEvent {}

class LogIn extends AuthEvent {
  LogIn({this.user});
  final User user;
}

class LogOut extends AuthEvent {}
