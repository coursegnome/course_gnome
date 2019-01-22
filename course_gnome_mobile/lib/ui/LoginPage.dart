import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:course_gnome/model/UtilityClasses.dart';

import 'package:course_gnome_mobile/ui/SearchPage.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _signInWithFB() async {
    _goToSearchPage();
//    var facebookLogin = new FacebookLogin();
//    var result = await facebookLogin.logInWithReadPermissions(['email']);
//
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        await widget._auth
//            .signInWithFacebook(accessToken: result.accessToken.token);
//        _goToSearchPage();
//        _sendTokenToServer(result.accessToken.token);
//        _showLoggedInUI();
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        _showCancelledMessage();
//        break;
//      case FacebookLoginStatus.error:
//        print(result.errorMessage);
//        _showErrorOnUI(result.errorMessage);
//        break;
//    }
  }

  _signInAnonymously() async {
//    await widget._auth.signInAnonymously();
    _goToSearchPage();
  }

  _goToSearchPage() {
//    Navigator.pushReplacement(context,
//        MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffED213A), Color(0xff93291E)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Text(
//                'Start scheduling now',
//                style: Theme.of(context)
//                    .textTheme
//                    .display3
//                    .copyWith(color: CGColors.cgred),
//              ),
              Image.asset('assets/images/whiteLogo.png', height: 70),
              Container(),
              Container(
                margin: EdgeInsets.only(top: 100),
                height: 50,
                child: RaisedButton.icon(
                  color: Color(0xff3b5998),
                  onPressed: _signInWithFB,
                  icon: Icon(
                    FontAwesomeIcons.facebookSquare,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text(
                    "Log in with Facebook",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
              FlatButton(
                onPressed: _signInAnonymously,
                child: Text(
                  "Continue as guest",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
