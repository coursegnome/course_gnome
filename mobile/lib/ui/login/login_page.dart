import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:core/core.dart';

import '../../utils/auth.dart';
import '../scheduling/scheduling_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _checkingFirstTimeUser = true;
  bool _keyboardIsOpen = false;
  double _currentPage = 0;

  final PageController _pageController = PageController();

  void _onPageChanged() {
    setState(() {
      _currentPage = _pageController.page;
    });
  }

  @override
  initState() {
    super.initState();
    _checkFirstTimeUser();
    _pageController.addListener(_onPageChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (_, AuthState authState) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Container(
                child: _checkingFirstTimeUser || authState is UninitiatedAuth
                    ? _loaderWidget()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // !_keyboardIsOpen
                          //     ? Image(
                          //         image: AssetImage('assets/images/logo.png',
                          //             package: 'core'),
                          //         width: 100,
                          //         height: 100,
                          //       )
                          // : Container(),
                          LoginPager(
                            keyboardOpen: _onKeyboardStateChanged,
                            pageController: _pageController,
                          ),
                          !_keyboardIsOpen
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_currentPage == 2
                                        ? 'Already have an account?'
                                        : 'Don\'t have an account?'),
                                    FlatButton(
                                      onPressed: () =>
                                          _pageController.animateToPage(
                                            _currentPage == 2 ? 1 : 2,
                                            duration:
                                                Duration(milliseconds: 350),
                                            curve: Curves.fastOutSlowIn,
                                          ),
                                      child: Text(
                                          _currentPage == 2
                                              ? 'Sign in'
                                              : 'Sign up',
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
    // setState(() {
    //   _keyboardIsOpen = isOpen;
    // });
  }

  Widget _loaderWidget() => CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(cgRed.asInt)));
  _goToSearchPage() {
    setFirstTimeStatus(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SchedulingPage()));
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

  bool _googleLoading = false;
  bool _signInLoading = false;

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
          _form(signIn: true),
          _form(signIn: false)
        ],
      ),
    );
  }

  Widget _startPage() {
    void _signInWithGoogle() async {
      setState(() {
        _googleLoading = true;
      });
      try {
        final GoogleSignInAccount account = await GoogleSignIn(
          scopes: [
            'email',
            'profile',
          ],
        ).signIn();
        if (account != null) {
          final auth = await account.authentication;
          auth.accessToken;
        }
        setState(() {
          _googleLoading = false;
        });
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
              onPressed: _signInWithGoogle,
              child: _googleLoading
                  ? Container(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black54)))
                  : Row(
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
    void _signInWithEmail({bool signIn}) async {
      setState(() {
        _signInLoading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      // BlocProvider.of<AuthBloc>(context).dispatch();
      setState(() {
        _signInLoading = false;
      });
    }

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
                      icon: Icon(Icons.school),
                    ),
                    items: [
                      DropdownMenuItem(
                          child: Text('George Washington University'))
                    ],
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
                icon: Icon(Icons.lock),
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
                    color: Color(cgRed.asInt),
                    textColor: Colors.white,
                    child: _signInLoading
                        ? Container(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white)))
                        : Text(signIn ? 'Sign In' : 'Sign Up'),
                    onPressed: () => _signInWithEmail(signIn: signIn),
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
