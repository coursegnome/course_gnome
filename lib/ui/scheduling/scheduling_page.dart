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
    Navigator.pushNamed(context, 'calendar');
  }

  @override
  Widget build(BuildContext context) {
    final bool twoColumn = MediaQuery.of(context).size.width > 500;
    List<IconData> actionIcons;
    if (twoColumn) {
      actionIcons = [
        Icons.edit,
        Icons.content_copy,
        Icons.remove_circle_outline,
        Icons.add_circle_outline,
      ];
    } else {
      actionIcons = [Icons.calendar_today];
    }
    final SearchPage searchPage = SearchPage(
      filtersAreOpen: _filtersAreOpen,
      filtersToggled: () => setState(() => _filtersAreOpen = !_filtersAreOpen),
    );
    return twoColumn
        ? Row(
            children: [
              Expanded(
                child: BasePage(
                  page: Page.Create,
                  actionIcons: actionIcons,
                  actionCallbacks: [() {}, () {}, () {}, () {}],
                  body: Row(
                    children: <Widget>[
                      Expanded(child: searchPage, flex: 5),
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
            body: searchPage,
            page: Page.Search,
            actionIcons: actionIcons,
            actionCallbacks: [() {}, _goToCalendar],
          );
  }
}
