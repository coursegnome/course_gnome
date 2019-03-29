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
    if (event is Init) {
      final User user = await authRepository.init();
      yield SignedIn(user: user);
    } else if (event is SignIn) {
      try {
        final User user = await authRepository.signIn();
        yield SignedIn(user: user);
      } catch (e) {
        print(e);
        if (currentState is SignedIn) {
          yield SignInError(user: currentState.user);
        }
      }
    } else {
      yield SignedOut();
    }
  }
}

abstract class AuthState {}

class SignedIn extends AuthState {
  SignedIn({this.user, this.isNewUser});
  final User user;
  final bool isNewUser;
}

class SignInError extends AuthState {
  SignInError({this.user});
  final User user;
}

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
