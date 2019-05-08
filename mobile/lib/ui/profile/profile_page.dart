import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/shared.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _facebookLoading = false;

  Widget _headline() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/pro-pic.jpeg'),
                radius: 70,
              ),
            ),
          ),
          Text(
            'Timothy Raymond Traversy',
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
          Text(
            'timtraversy@gwu.edu',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }

  Widget _labelAndInfo(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: Colors.black54),
          ),
          Text(info,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Facebook'.toUpperCase(),
            textAlign: TextAlign.center,
          ),
          CGButton(
            icon: FontAwesomeIcons.facebook,
            onPressed: _connectFacebook,
            customColor: Color(0xff3B5998),
            text: 'Connect Account',
            loading: _facebookLoading,
            primary: true,
          ),
        ],
      ),
    );
  }

  _connectFacebook() async {
    setState(() {
      _facebookLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _facebookLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      page: Page.Profile,
      showDrawer: false,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(30),
        children: <Widget>[
          _headline(),
          _labelAndInfo('School', 'George Washington University'),
          _labelAndInfo('Year', 'Senior'),
          _facebookButton(),
        ],
      ),
    );
  }
}
