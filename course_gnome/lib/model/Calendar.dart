import 'dart:collection';
import 'dart:convert';

import 'UtilityClasses.dart';
import 'Course.dart';

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
    final List<dynamic> calendars = json['list'];
    list = [];
    calendars.forEach((cal) => list.add(Calendar.fromJson(cal)));
  }

  Map<String, dynamic> toJson() => {
        'list': list,
        'currentCalendarIndex': currentCalendarIndex,
      };

  static Calendars init(String jsonString) {
    if (jsonString == null) {
      final calendars = Calendars();
      calendars.addCalendar(initialCalName);
      return calendars;
    }
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Calendars.fromJson(json);
  }

  addCalendar(String name) {
    final cal = Calendar(name);
    list.add(cal);
    currentCalendarIndex = list.length - 1;
  }

  removeCalendar(Calendar calendar) {
    list.remove(calendar);
  }
}

class Calendar {
  String name;
  HashSet<String> ids;
  List<List<ClassBlock>> blocksByDay;

  Calendar(name) {
    this.name = name;
    ids = HashSet<String>();
    blocksByDay = List.generate(7, (i) => List<ClassBlock>());
  }

  Calendar.fromJson(Map<String, dynamic> json) {
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

  toggleOffering(Course course, Offering offering, TriColor color) {
    if (ids.contains(offering.crn)) {
      removeOffering(offering.crn);
    } else {
      _addOffering(course, offering, color);
    }
  }

  _addOffering(Course course, Offering offering, TriColor color) {
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
  }

  removeOffering(String id) {
    ids.remove(id);
    blocksByDay.forEach((list) => list.removeWhere((block) => block.id == id));
  }
}

class ClassBlock {
  double offset, height;
  String departmentInfo, id, name;
  TriColor color;

  ClassBlock(this.offset, this.height, this.departmentInfo, this.id, this.name,
      this.color);

  ClassBlock.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    height = json['height'];
    departmentInfo = json['departmentInfo'];
    id = json['id'];
    name = json['name'];
    color = TriColor.fromJson(json["color"]);
  }

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'height': height,
        'departmentInfo': departmentInfo,
        'id': id,
        'name': name,
        'color': color,
      };
}
