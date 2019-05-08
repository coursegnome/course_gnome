import 'package:flutter/material.dart';

import 'login_base.dart';
import 'sign_up_options.dart';
import '../shared/shared.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _school;
  int _year;

  void _goToSignUpOptionsPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpOptions()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: LoginBase(
        title: 'Tell us about yourself',
        children: <Widget>[
          DropdownButtonFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.school),
              labelText: 'School',
            ),
            value: _school,
            onChanged: (val) => setState(() {
                  _school = val;
                }),
            items: [
              DropdownMenuItem(
                child: Text('GWU'),
                value: 'GWU',
              )
            ],
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.star),
              labelText: 'Year',
            ),
            value: _year,
            onChanged: (val) => setState(() {
                  _year = val;
                }),
            items: [
              DropdownMenuItem(child: Text('Fresman'), value: 1),
              DropdownMenuItem(child: Text('Sophomore'), value: 2),
              DropdownMenuItem(child: Text('Junior'), value: 3),
              DropdownMenuItem(child: Text('Senior'), value: 4),
              DropdownMenuItem(child: Text('Other'), value: 0),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.person),
              labelText: 'Name',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          CGButton(
            primary: true,
            onPressed: _goToSignUpOptionsPage,
            text: 'I\'m done',
          ),
        ],
      ),
    );
  }
}
