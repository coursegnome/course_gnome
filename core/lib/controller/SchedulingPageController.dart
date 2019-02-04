
import 'package:core/model/Calendar.dart';
import 'package:core/model/Course.dart';
import 'package:core/model/UtilityClasses.dart';
import 'package:core/services/Networking.dart';

class SchedulingPageController {
  Calendars calendars = null;
  Function calendarUpdated;
  CalendarsHistory calendarsHistory = CalendarsHistory();

  saveEdit() {
    calendarsHistory.update(calendars);
    calendarUpdated();
  }

  initCalendars(jsonString) {
    calendars = Calendars.init(jsonString);
    calendarsHistory.update(calendars);
  }

  // Calendars
  var calendarValues = CalendarValues();
  scaleHorizontally(double initialValue, double scale) {
    final width = initialValue * scale;
    if (width > CalendarValues.maxDayWidth || width < CalendarValues.minDayWidth) return;
    calendarValues.dayWidth = width;
  }
  scaleVertically(double initialValue, double scale) {
    final height = initialValue * scale;
    if (height > CalendarValues.maxHourHeight || height < CalendarValues.minHourHeight) return;
    calendarValues.hourHeight = height;
  }

  onCalendarTextChanged() {}

  onCurrentCalendarChanged(int index) {
    saveEdit();
  }

  addCalendar(String name) {
    calendars.addCalendar(name);
    saveEdit();
  }

  editCurrentCalendarName(String name) {
    calendars.currentCalendar().name = name;
    saveEdit();
  }

  // TODO test this for two/three cals, index checking
  deleteCurrentCalendar() {
    calendars.removeCalendar(calendars.currentCalendar());
    if (calendars.currentCalendarIndex > 0) {
      calendars.currentCalendarIndex--;
    }
    saveEdit();
  }

  undo() {
    calendars = calendarsHistory.goBackwards();
  }

  redo() {
    calendars = calendarsHistory.goForwards();
  }

  // Searching
  var searchObject = SearchObject();
  var searchResults = SearchResults();

//  TriColor colorFromIndex(int i) {
//    print(calendars.currentCalendar().colors.length);
//    return calendars
//        .currentCalendar()
//        .colors[i % calendars.currentCalendar().colors.length];
//  }

  toggleOffering(Course course, Offering offering, TriColor color) {
    calendars.currentCalendar().toggleOffering(course, offering, color);
    saveEdit();
  }

  removeOffering(String id) {
    calendars.currentCalendar().removeOffering(id);
    saveEdit();
  }

  getSearchResults() async {
    searchResults = await Networking.getCourses(searchObject);
  }

  loadMoreResults() async {
    searchObject.offset += 10;
    try {
      final _moreResults = await Networking.getCourses(searchObject);
      searchResults.results.addAll(_moreResults.results);
    } catch (err) {
      searchObject.offset -= 10;
    }
  }

  clearResults() {
    searchResults.clear();
  }
}

class CalendarValues {
  static const hourCount = 17;
  static const startHour = 7;
  static const dayCount = 7;
  static final minHourHeight = 60.0;
  static final minDayWidth = 60.0;
  static final maxHourHeight = 140.0;
  static final maxDayWidth = 140.0;
  var hourHeight = 100.0;
  var dayWidth = 100.0;
}
