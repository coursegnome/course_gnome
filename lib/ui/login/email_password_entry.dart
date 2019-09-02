import 'package:flutter/material.dart';

import '../shared/shared.dart';
import 'login_base.dart';
import '../scheduling/scheduling_page.dart';

class EmailPasswordEntry extends StatefulWidget {
  EmailPasswordEntry({@required this.signingIn});
  final bool signingIn;
  @override
  _EmailPasswordEntryState createState() => _EmailPasswordEntryState();
}

class _EmailPasswordEntryState extends State<EmailPasswordEntry> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  void _signInOrUp() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _loading = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SchedulingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: LoginBase(
        title: widget.signingIn ? 'Sign in' : 'Almost there!',
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.email),
                labelText: 'EMAIL',
                suffixText: widget.signingIn ? null : '@gwu.edu',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an email address';
                }
              },
              textAlign: widget.signingIn ? TextAlign.start : TextAlign.end,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.lock),
              labelText: 'PASSWORD',
            ),
            obscureText: true,
          ),
          CGButton(
            loading: _loading,
            primary: true,
            text: widget.signingIn ? 'Sign in' : 'Sign up',
            onPressed: _signInOrUp,
          )
        ],
      ),
    );
  }
}
