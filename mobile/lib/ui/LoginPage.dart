import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:core/core.dart';

import 'package:course_gnome_mobile/utils/auth.dart';
//import 'package:course_gnome_mobile/ui/SchedulingPage.dart';

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
          return Container(
            color: Colors.white,
            child: Center(
              child: _checkingFirstTimeUser
                  ? _checkingUserLoader()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/images/logo.png',
                              package: 'core'),
                          width: 100,
                          height: 100,
                        ),
//                    LoginPager(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Don\'t have an account?',
                            ),
                            FlatButton(
                              child: Text('Sign Up'),
                            ),
                          ],
                        ),
                        FlatButton(
                          child: Text('Continue as guest'),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _checkingUserLoader() {
    return Container();
  }

  _goToSearchPage() {
    setFirstTimeStatus(true);
//    Navigator.pushReplacement(context,
//        MaterialPageRoute(builder: (BuildContext context) => SchedulingPage()));
  }
}

class LoginPager extends StatefulWidget {
  @override
  _LoginPagerState createState() => _LoginPagerState();
}

class _LoginPagerState extends State<LoginPager> {
  final _formKey = GlobalKey<FormState>();
  final _pagerController = PageController();
  bool _checkingFirstTimeUser = true;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pagerController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        _startPage(),
        _form(
          signIn: true,
        ),
        _form(signIn: false)
      ],
    );
  }

  Widget _startPage() {
    void _signInWithGoogle() async {
      try {
        final GoogleSignInAccount account = await GoogleSignIn(
          scopes: [
            'email',
            'profile',
          ],
        ).signIn();
      } catch (e) {
        print(e);
      }
    }

    return Column(
      children: <Widget>[
        Text('Find classes and build schedules with Course Gnome.'),
        RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.email),
          label: Text('Sign in with email'),
        ),
        RaisedButton.icon(
          onPressed: _signInWithGoogle,
          icon: Icon(FontAwesomeIcons.google),
          label: Text('Sign in with email'),
        )
      ],
    );
  }

  Widget _form({bool signIn}) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          signIn
              ? DropdownButtonFormField(
                  items: [],
                )
              : Container(),
          TextFormField(
            decoration: InputDecoration(
              suffixText: '@gwu.edu',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an email address';
              }
            },
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(signIn ? 'Sign In' : 'Sign Up'),
              ),
              RaisedButton(
                child: Text(signIn ? 'Sign In' : 'Sign Up'),
              )
            ],
          )
        ],
      ),
    );
  }
}
