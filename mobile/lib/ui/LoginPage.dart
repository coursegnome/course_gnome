import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:flutter_facebook_login_login/flutter_facebook_login.dart';

import 'package:course_gnome_mobile/ui/SchedulingPage.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  }

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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SchedulingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffF5AF19), Color(0xffF12711)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/logo.png', height: 125),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: 'Find classes and build schedules with ',
                        ),
                        TextSpan(
                            text: 'Course Gnome.',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 50,
                child: RaisedButton.icon(
                  color: Colors.white,
                  onPressed: _signInWithGoogle,
                  icon: Image.asset(
                    'assets/images/google-logo.png',
                    height: 35,
                  ),
                  label: Text(
                    "Log in with Google",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
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
