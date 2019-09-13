import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:course_gnome/ui/shared/shared.dart';
import 'package:course_gnome/ui/scheduling/scheduling.dart';
import 'package:course_gnome/ui/search/search.dart';

class SchedulingPage extends StatefulWidget {
  @override
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  bool _filtersAreOpen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  }

  _goToCalendar() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarPage()));
  }

  @override
  Widget build(BuildContext context) {
    final bool twoColumn = MediaQuery.of(context).size.width > 500;
    List<IconData> actionIcons = [Icons.filter_list];
    if (!twoColumn) {
      actionIcons.add(Icons.calendar_today);
    }
    return twoColumn
        ? Row(
            children: [
              Expanded(
                child: BasePage(
                  page: Page.Create,
                  body: Row(
                    children: <Widget>[
                      Expanded(
                          child: SearchPage(
                            filtersAreOpen: _filtersAreOpen,
                            filtersToggled: () => setState(
                                () => _filtersAreOpen = !_filtersAreOpen),
                          ),
                          flex: 5),
                      Expanded(
                          child: CalendarPage(
                            filtersAreOpen: _filtersAreOpen,
                          ),
                          flex: _filtersAreOpen ? 1 : 5)
                    ],
                  ),
                ),
              ),
            ],
          )
        : BasePage(
            body: SearchPage(),
            page: Page.Search,
            actionIcons: actionIcons,
            actionCallbacks: [() {}, _goToCalendar],
          );
  }
}
