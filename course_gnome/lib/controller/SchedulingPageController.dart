import 'package:course_gnome/model/Calendar.dart';
import 'package:course_gnome/model/Course.dart';
import 'package:course_gnome/model/UtilityClasses.dart';
import 'package:course_gnome/services/Networking.dart';

class SchedulingPageController {
  Calendars calendars = null;
  Function calendarUpdated;

  initCalendars(jsonString) {
    calendars = Calendars.init(jsonString);
  }

  // Calendars
  onCalendarTextChanged() {}
  onCurrentCalendarChanged(int index) {
    calendars.currentCalendarIndex = index;
    calendarUpdated();
  }

  addCalendar(String name) {
    calendars.addCalendar(name);
    calendarUpdated();
  }

  editCurrentCalendarName(String name) {
    calendars.currentCalendar().name = name;
    calendarUpdated();
  }

  // TODO test this for two/three cals, index checking
  deleteCurrentCalendar() {
    calendars.removeCalendar(calendars.currentCalendar());
    calendarUpdated();
  }

  // Searching
  var searchObject = SearchObject();
  var searchResults = SearchResults();

  toggleOffering(Course course, Offering offering, TriColor color) {
    calendars.currentCalendar().toggleOffering(course, offering, color);
    calendarUpdated();
  }

  removeOffering(String id) {
    calendars.currentCalendar().removeOffering(id);
    calendarUpdated();
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
