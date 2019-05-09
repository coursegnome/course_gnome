import 'package:flutter/material.dart';

import '../../shared/shared.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({@required this.singleColumn});
  final bool singleColumn;
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      page: Page.Calendar,
      body: Container(),
      showDrawer: !widget.singleColumn,
    );
  }
}
