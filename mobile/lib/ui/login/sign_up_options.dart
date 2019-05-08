import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/shared.dart';
import 'email_password_entry.dart';
import 'login_base.dart';

class SignUpOptions extends StatefulWidget {
  @override
  _SignUpOptionsState createState() => _SignUpOptionsState();
}

class _SignUpOptionsState extends State<SignUpOptions> {
  bool _googleSignUpLoading = false;
  @override
  Widget build(BuildContext context) {
    return LoginBase(
      title: 'Choose a sign up option',
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CGButton(
              onPressed: _signUpWithGoogle,
              text: 'Sign up with Google',
              icon: FontAwesomeIcons.google,
              primary: true,
              loading: _googleSignUpLoading,
            ),
            Text(
              'If you use Google, you still have to use your school-provided Gmail account',
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        CGButton(
          onPressed: _goToSignUpPage,
          text: 'Sign up with email',
          icon: Icons.mail,
          primary: false,
        ),
      ],
    );
  }

  void _signUpWithGoogle() async {
    setState(() {
      _googleSignUpLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _googleSignUpLoading = false;
    });
  }

  void _goToSignUpPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EmailPasswordEntry(
                  signingIn: false,
                )));
  }
}
