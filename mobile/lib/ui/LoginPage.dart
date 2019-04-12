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
  bool _keyboardIsOpen = false;
  final PageController _pageController = PageController();

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

  _onKeyboardStateChanged(bool isOpen) {
    setState(() {
      _keyboardIsOpen = isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (_, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: _checkingFirstTimeUser
                    ? _checkingUserLoader()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          !_keyboardIsOpen
                              ? Image(
                                  image: AssetImage('assets/images/logo.png',
                                      package: 'core'),
                                  width: 100,
                                  height: 100,
                                )
                              : Container(),
                          LoginPager(
                            keyboardOpen: _onKeyboardStateChanged,
                            pageController: _pageController,
                          ),
                          !_keyboardIsOpen
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Don\'t have an account?'),
                                    FlatButton(
                                      onPressed: () =>
                                          _pageController.animateToPage(
                                            2,
                                            duration:
                                                Duration(milliseconds: 350),
                                            curve: Curves.fastOutSlowIn,
                                          ),
                                      child: Text('Sign Up',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              : Container(),
                          !_keyboardIsOpen
                              ? FlatButton(
                                  child: Text('Continue as guest'),
                                )
                              : Container(),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
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
  LoginPager({this.keyboardOpen, this.pageController});
  final PageController pageController;
  final ValueChanged<bool> keyboardOpen;
  @override
  _LoginPagerState createState() => _LoginPagerState();
}

class _LoginPagerState extends State<LoginPager>
    with AutomaticKeepAliveClientMixin {
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  PageController get _pageController => widget.pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_focusChange);
    _passwordFocusNode.addListener(_focusChange);
  }

  _focusChange() {
    widget
        .keyboardOpen(_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _startPage(),
          _form(
            signIn: true,
          ),
          _form(signIn: false)
        ],
      ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Find classes and build schedules with Course Gnome.',
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontFamily: 'Merriweather'),
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            width: 250,
            child: MaterialButton(
              padding: const EdgeInsets.all(14.0),
              onPressed: () => _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 350),
                    curve: Curves.fastOutSlowIn,
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.email),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Sign in with email'),
                  ),
                ],
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            width: 250,
            child: MaterialButton(
              padding: const EdgeInsets.all(14.0),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.google),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Sign in with Google'),
                  ),
                ],
              ),
              color: Color(lightGray.asInt),
              textColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _form({bool signIn}) {
    return Form(
      key: signIn ? _signInFormKey : _signUpFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !signIn
                ? DropdownButtonFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.school), labelText: 'SCHOOL'),
                    items: [DropdownMenuItem(child: Text('GWU'))],
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'EMAIL',
                  suffixText: signIn ? null : '@gwu.edu',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an email address';
                  }
                },
                textAlign: signIn ? TextAlign.start : TextAlign.end,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            TextFormField(
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                labelText: 'PASSWORD',
              ),
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => _pageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 350),
                            curve: Curves.fastOutSlowIn,
                          )),
                  RaisedButton(
                    child: Text(signIn ? 'Sign In' : 'Sign Up'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
