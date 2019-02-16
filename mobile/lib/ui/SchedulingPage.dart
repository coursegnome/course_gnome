import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/model/UtilityClasses.dart';
import 'package:core/controller/SchedulingPageController.dart';

import 'package:course_gnome_mobile/ui/SearchPage.dart';
import 'package:course_gnome_mobile/ui/CalendarPage.dart';

class SchedulingPage extends StatefulWidget {
  @override
  _SchedulingPageState createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage>
    with TickerProviderStateMixin {
  final _schedulingPageController = SchedulingPageController();
  PageController _pageController = PageController(keepPage: true);
  TabController _tabController;
  TextEditingController _calendarNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _schedulingPageController.calendarUpdated = _calendarUpdated;
    initCal();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _calendarNameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  initCal() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString("calendars");
    setState(() {
      _schedulingPageController.initCalendars(jsonString);
      _tabController = TabController(
        length: _schedulingPageController.calendars.list.length,
        vsync: this,
        initialIndex: _schedulingPageController.calendars.currentCalendarIndex,
      );
    });
    _tabController.addListener(_tabChanged);
  }

  _calendarUpdated() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString("calendars", jsonEncode(_schedulingPageController.calendars));
  }

  _tabChanged() {
//    print(_tabController.index);
    _schedulingPageController.onCurrentCalendarChanged(_tabController.index);
  }

  _toggleActivePage() {
    _unfocusKeyboard();
    var _page = _pageController.page.round() == 0 ? 1 : 0;
    _pageController.animateToPage(_page,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  _unfocusKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  _getSearchResults() {
    setState(() {
      _schedulingPageController.getSearchResults();
    });
  }

  _loadMoreResults() async {
    setState(() {
      _schedulingPageController.loadMoreResults();
    });
  }

  _clearResults() {
    setState(() {
      _schedulingPageController.clearResults();
    });
  }

  _toggleOffering(course, offering, color) {
    setState(() {
      _schedulingPageController.toggleOffering(course, offering, color);
    });
  }

  _setState() {}

  // Calendar Page logic
  _addCalendar() {
    final name = _calendarNameController.text;
    if (name.isEmpty) return;
    setState(() {
      _schedulingPageController.addCalendar(name);
      _tabController = TabController(
        length: _schedulingPageController.calendars.list.length,
        vsync: this,
      );
      _tabController.addListener(_tabChanged);
    });
    Navigator.pop(context);
    _tabController.animateTo(_tabController.length - 1);
    _calendarNameController.clear();
  }

  _editCurrentCalendarName() {
    setState(() {
      _schedulingPageController
          .editCurrentCalendarName(_calendarNameController.text);
    });
    Navigator.pop(context);
    _calendarNameController.clear();
  }

  _deleteCurrentCalendar() {
    setState(() {
      _schedulingPageController.deleteCurrentCalendar();
      if (_tabController.index > 0) {
        _tabController = TabController(
          length: _schedulingPageController.calendars.list.length,
          vsync: this,
        );
      }
    });
    Navigator.pop(context);
  }

  _removeOffering(String id) {
    setState(() {
      _schedulingPageController.removeOffering(id);
    });
  }

  _scaleCalendarHorizontally(double initialValue, double scale) {
    setState(() {
      _schedulingPageController.scaleHorizontally(initialValue, scale);
    });
  }

  _scaleCalendarVertically(double initialValue, double scale) {
    setState(() {
      _schedulingPageController.scaleHorizontally(initialValue, scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final search = SearchPage(
      schedulingPageController: _schedulingPageController,
      clearResults: _clearResults,
      loadMoreResults: _loadMoreResults,
      getSearchResults: _getSearchResults,
      toggleActivePage: _toggleActivePage,
      toggleOffering: _toggleOffering,
    );
    final calendar = CalendarPage(
      schedulingPageController: _schedulingPageController,
      calendarNameController: _calendarNameController,
      tabController: _tabController,
      addCalendar: _addCalendar,
      editCurrentCalendarName: _editCurrentCalendarName,
      deleteCurrentCalendar: _deleteCurrentCalendar,
      removeOffering: _removeOffering,
      toggleActivePage: _toggleActivePage,
      scaleCalendarHorizontally: _scaleCalendarHorizontally,
      scaleCalendarVertically: _scaleCalendarVertically,
    );
    return _schedulingPageController.calendars != null
        ? width >= Breakpoints.split
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: search,
                  ),
                  Expanded(child: calendar)
                ],
              )
            : PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                children: [search, calendar],
                onPageChanged: (i) => _unfocusKeyboard,
              )
        : Container();
  }
}
