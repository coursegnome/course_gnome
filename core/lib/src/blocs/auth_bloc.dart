import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({this.authRepository});
  final AuthRepository authRepository;

  @override
  AuthState get initialState => SignedOut();

  @override
  Stream<AuthState> mapEventToState(
    AuthState currentState,
    AuthEvent event,
  ) async* {
    yield AuthLoading();
    if (event is Init) {
      final User user = await authRepository.init();
      yield user == null ?
        SignedOut():
        SignedIn(user);
    } else if (event is SignIn) {
      try {
        final User user = await authRepository.signIn(
          username: event.username,
          password: event.password,
        );
        yield SignedIn(user);
      } catch (e) {
        print(e);
        if (currentState is SignedIn) {
          yield AuthError(user: currentState.user);
        }
      }
    } else if (event is SignUp) {
      try {
        final User user = await authRepository.signUp(
          username: event.username,
          password: event.password,
        );
        yield SignedIn(user);
      } catch (e) {
        print(e);
        if (currentState is SignedIn) {
          yield AuthError(user: currentState.user);
        }
      }
    }
  }
}

abstract class AuthState {}

class SignedIn extends AuthState {
  SignedIn(this.user);
  final User user;
}

class AuthError extends AuthState {
  AuthError({this.user});
  final User user;
}

class AuthLoading extends AuthState {}

class SignedOut extends AuthState {}

abstract class AuthEvent {}

class Init extends AuthEvent {}

class SignUp extends AuthEvent {
  SignUp({this.username, this.password});
  final String username, password;
}

class CancelSignUp extends AuthEvent {}

class SignIn extends AuthEvent {
  SignIn({this.username, this.password});
  final String username, password;
}

class CancelSignIn extends AuthEvent {}

class SignOut extends AuthEvent {}
