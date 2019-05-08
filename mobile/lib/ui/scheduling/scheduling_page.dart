import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/core.dart';

import '../shared/shared.dart';

class SchedulingPage extends StatefulWidget {
  @override
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      page: Page.Scheduling,
      body: Container(),
    );
  }
}
