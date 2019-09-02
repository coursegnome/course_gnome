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
  bool _validatedOnce = false;

  void _goToSignUpOptionsPage() {
    _validatedOnce = true;
    if (_formKey.currentState.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SignUpOptions()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: LoginBase(
        title: 'Tell us about yourself',
        children: <Widget>[
          DropdownButtonFormField(
            validator: (val) {
              if (val == null) {
                return 'Please choose a school.';
              }
            },
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.school),
              labelText: 'School',
            ),
            value: _school,
            onChanged: (val) => setState(() {
                  if (_validatedOnce) _formKey.currentState.validate();
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
            validator: (val) {
              if (val == null) {
                return 'Please choose a year.';
              }
            },
            onChanged: (val) => setState(() {
                  if (_validatedOnce) _formKey.currentState.validate();
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
            // onEditingComplete: () {
            //   print('i');
            //   return true;
            // },
            onFieldSubmitted: (x) {
              if (_validatedOnce) _formKey.currentState.validate();
              print('ee');
            },
            validator: (val) {
              if (val == "") {
                return 'Please enter your name.';
              }
            },
            // onSaved: (String i) {
            //   _formKey.currentState.validate();
            // },
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
