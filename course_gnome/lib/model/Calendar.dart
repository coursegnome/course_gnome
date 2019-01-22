import 'dart:collection';
import 'dart:convert';

import 'package:course_gnome/model/UtilityClasses.dart';
import 'package:course_gnome/model/Course.dart';

class Calendars {
  static const String initialCalName = "My Calendar";

  int currentCalendarIndex;
  List<Calendar> list;

  Calendar currentCalendar() => list[currentCalendarIndex];

  Calendars() {
    list = [];
  }

  Calendars.fromJson(Map<String, dynamic> json) {
    currentCalendarIndex = json['currentCalendarIndex'];
    final List<Map<String, dynamic>> calendars = json['list'];
    list = [];
    calendars
        .forEach((cal) => list.add(Calendar.fromJson(cal, _calendarsUpdated)));
  }

  Map<String, dynamic> toJson() => {
        'list': list,
        'currentCalendarIndex': currentCalendarIndex,
      };

  init() async {
    final sp = await SharedPreferences.getInstance();
//    sp.clear();
    final jsonString = sp.getString("calendars");
    if (jsonString == null) {
//      print('No saved cals, create initial one');
      this.addCalendar(initialCalName);
      return;
    }
//    print('Load saved cals');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    currentCalendarIndex = json['currentCalendarIndex'];
    final List<dynamic> calendars = json['list'];
    calendars
        .forEach((cal) => list.add(Calendar.fromJson(cal, _calendarsUpdated)));
  }

  addCalendar(String name) {
    final cal = Calendar(_calendarsUpdated, name);
    list.add(cal);
    // behavior for now is we set this calendar to be the current one
    currentCalendarIndex = list.length - 1;
    _calendarsUpdated();
  }

  removeCalendar(Calendar calendar) {
    list.remove(calendar);
    _calendarsUpdated();
  }

  _calendarsUpdated() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString("calendars", jsonEncode(this));
  }
}

class Calendar {
  String name;
  HashSet<String> ids;
  List<List<ClassBlock>> blocksByDay;
  Function calendarUpdated;

  Calendar(calendarUpdated, name) {
    this.calendarUpdated = calendarUpdated;
    this.name = name;
    ids = HashSet<String>();
    blocksByDay = List.generate(7, (i) => List<ClassBlock>());
  }

  Calendar.fromJson(Map<String, dynamic> json, calendarUpdated) {
    this.calendarUpdated = calendarUpdated;
    name = json['name'];
    ids = HashSet<String>();
    List idsList = json['ids'] as List;
    idsList.forEach((id) => ids.add(id));
    final List<dynamic> blocksByDay = json['blocksByDay'];
    this.blocksByDay = List.generate(7, (i) => List<ClassBlock>());
    for (var i = 0; i < blocksByDay.length; ++i) {
      blocksByDay[i].forEach(
        (block) => this.blocksByDay[i].add(
              ClassBlock.fromJson(block),
            ),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'ids': ids.toList(),
        'blocksByDay': blocksByDay,
      };

  toggleOffering(Course course, Offering offering, CGColor color) {
    if (ids.contains(offering.crn)) {
      removeOffering(offering.crn);
    } else {
      addOffering(course, offering, color);
    }
  }

  addOffering(Course course, Offering offering, CGColor color) {
    ids.add(offering.crn);
    for (var classTime in offering.classTimes) {
      final offset = classTime.startTime.hour + classTime.startTime.minute / 60;
      final height = classTime.endTime.hour -
          classTime.startTime.hour +
          (classTime.endTime.minute - classTime.startTime.minute) / 60;
      final departmentInfo =
          course.departmentAcronym + ' ' + course.departmentNumber;
      for (var i = 0; i < classTime.days.length; ++i) {
        if (!classTime.days[i]) {
          continue;
        }
        blocksByDay[i].add(ClassBlock(
            offset, height, departmentInfo, offering.crn, course.name, color));
      }
    }
    calendarUpdated();
  }

  removeOffering(String id) {
    ids.remove(id);
    blocksByDay.forEach((list) => list.removeWhere((block) => block.id == id));
    calendarUpdated();
  }
}

class ClassBlock {
  double offset, height;
  String departmentInfo, id, name;
  CGColor color;

  ClassBlock(this.offset, this.height, this.departmentInfo, this.id, this.name,
      this.color);

  ClassBlock.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    height = json['height'];
    departmentInfo = json['departmentInfo'];
    id = json['id'];
    name = json['name'];
    color = CGColor(json["color-light"], json["color-med"], json["color-dark"]);
  }

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'height': height,
        'departmentInfo': departmentInfo,
        'id': id,
        'name': name,
        'color-light': color.light.value,
        'color-med': color.med.value,
        'color-dark': color.dark.value,
      };
}
