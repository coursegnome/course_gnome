import 'package:flutter/material.dart';

class LoginBase extends StatelessWidget {
  LoginBase({this.title, this.children});
  final String title;
  final List<Widget> children;

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> paddedChildren = children.map((Widget child) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: child,
      );
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Center(
                  child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
                    children: paddedChildren ?? [],
                  ),
                ),
              ),
              Container(
                width: 40.0,
                child: FlatButton(
                  child: Text('Back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
