import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:core/core.dart';

import '../../utils/auth.dart';
import '../scheduling/scheduling_page.dart';
import 'sign_up_form.dart';
import 'email_password_entry.dart';
import '../shared/shared.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _checkingFirstTimeUser = true;
  bool _googleSignInLoading = false;

  @override
  initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black87));
    _checkFirstTimeUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (_, AuthState authState) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: _checkingFirstTimeUser //|| authState is UninitiatedAuth
                    ? _loaderWidget()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/logo.png',
                                package: 'core'),
                            width: 100,
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Text(
                              'Find classes and build schedules with Course Gnome.',
                              style: Theme.of(context).textTheme.display1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          CGButton(
                            onPressed: _signInWithGoogle,
                            text: 'Sign in with Google',
                            icon: FontAwesomeIcons.google,
                            primary: true,
                            loading: _googleSignInLoading,
                          ),
                          CGButton(
                            onPressed: _goToSignInPage,
                            text: 'Sign in with email',
                            icon: Icons.mail,
                            primary: false,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have an account?'),
                                FlatButton(
                                  onPressed: _goToSignUpPage,
                                  child: Text('Sign up',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  _checkFirstTimeUser() async {
    if (await isFirstTimeUser()) {
      setState(() {
        _checkingFirstTimeUser = false;
      });
    } else {
      _goToSearchPage();
    }
  }

  Widget _loaderWidget() => CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(cgRed.asInt)));

  _goToSignUpPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpForm()));
  }

  _goToSignInPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                EmailPasswordEntry(signingIn: true)));
  }

  _goToSearchPage() {
    setFirstTimeStatus(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SchedulingPage()));
  }

  _signInWithGoogle() async {
    setState(() {
      _googleSignInLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _googleSignInLoading = false;
    });
  }
}
