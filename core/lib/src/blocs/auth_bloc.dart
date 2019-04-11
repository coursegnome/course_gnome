import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({this.authRepository});
  final AuthRepository authRepository;

  @override
  AuthState get initialState => UnitiatedAuth();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is Init) {
      final User user = await authRepository.init();
      yield user == null ? SignedOut() : SignedIn(user);
    } else if (event is SignIn) {
      yield AuthLoading();
      try {
        final User user = await authRepository.signIn(
          username: event.username,
          password: event.password,
          school: event.school,
        );
        yield SignedIn(user);
      } catch (e) {
        print(e);
        if (currentState is SignedIn) {
          yield AuthError(user: (currentState as SignedIn).user);
        }
      }
    } else if (event is SignUp) {
      yield AuthLoading();
      try {
        final User user = await authRepository.signUp(
          username: event.username,
          password: event.password,
          school: event.school,
          userType: event.userType,
        );
        yield SignedIn(user);
      } catch (e) {
        print(e);
        if (currentState is SignedIn) {
          yield AuthError(user: (currentState as SignedIn).user);
        }
      }
    }
  }
}

abstract class AuthState {}

class UnitiatedAuth extends AuthState {}

class SignedIn extends AuthState {
  SignedIn(this.user);
  final User user;
}

class AuthError extends AuthState {
  AuthError({this.user});
  final User user;
}

class AuthLoading extends AuthState {}

class SignedOut extends AuthState {
  SignedOut({this.newUser});
  final bool newUser;
}

abstract class AuthEvent {}

class Init extends AuthEvent {}

class SignUp extends AuthEvent {
  SignUp({
    this.username,
    this.password,
    this.school,
    this.userType,
  });
  final String username, password;
  final School school;
  final UserType userType;
}

class CancelSignUp extends AuthEvent {}

class SignIn extends AuthEvent {
  SignIn({this.username, this.password, this.school});
  final String username, password;
  final School school;
}

class CancelSignIn extends AuthEvent {}

class SignOut extends AuthEvent {}
