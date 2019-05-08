import 'package:flutter/material.dart';

import '../shared/shared.dart';

class SchedulesPage extends StatefulWidget {
  @override
  _SchedulesPageState createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      page: Page.Schedules,
      body: Container(),
    );
  }
}
