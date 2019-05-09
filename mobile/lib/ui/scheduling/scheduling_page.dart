import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:core/core.dart';

import '../scheduling/search/search_page.dart';
import '../scheduling/calendar/calendar_page.dart';

class SchedulingPage extends StatefulWidget {
  @override
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    final bool twoColumn = MediaQuery.of(context).size.width > 500;
    return twoColumn
        ? Row(children: [
            Expanded(
                child: SearchPage(
              singleColumn: false,
            )),
            Expanded(
                child: CalendarPage(
              singleColumn: false,
            )),
          ])
        : SearchPage(
            singleColumn: true,
          );
  }
}
