import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core.dart';

import 'package:course_gnome_mobile/utils/auth.dart';
import 'package:course_gnome_mobile/ui/SchedulingPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _checkingFirstTimeUser = true;

  @override
  initState() {
    super.initState();
    _checkFirstTimeUser();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (_, state) {
        if (!state is SignedIn) {
          _goToSearchPage();
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (_, state) {
          return _checkingFirstTimeUser
              ? _checkingUserLoader()
              : Column(
                  children: <Widget>[
                    Image.asset(''),
                    LoginPager(),
                    Row(
                      children: [
                        Text('Don\'t have an account?'),
                        FlatButton(
                          child: Text('Sign Up'),
                        ),
                      ],
                    ),
                    FlatButton(
                      child: Text('Continue as guest'),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _checkingUserLoader() {
    return Container();
  }

/*
  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await widget._auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }*/

  _goToSearchPage() {
    setFirstTimeStatus(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SchedulingPage()));
  }
}

class LoginPager extends StatefulWidget {
  @override
  _LoginPagerState createState() => _LoginPagerState();
}

class _LoginPagerState extends State<LoginPager> {
  bool _checkingFirstTimeUser = true;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
