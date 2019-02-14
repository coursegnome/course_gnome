import 'dart:collection';
import 'dart:convert';

import 'Course.dart';

class CalendarsHistory {
  int current = 0;
  List<Calendars> history = [];

  void update(Calendars calendars) {
    history = history.sublist(0, current);
    history.add(calendars);
    current = history.length - 1;
  }

  Calendars goBackwards() {
    if (current != 0) {
      --current;
    }
    return history[current];
  }

  Calendars goForwards() {
    if (current != history.length - 1) {
      ++current;
    }
    return history[current];
  }
}

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
//  List<TriColor> colors = [];
  List<List<ClassBlock>> blocksByDay;

  Calendar(name) {
    this.name = name;
//    colors.addAll(CGColors.array);
    ids = HashSet<String>();
    blocksByDay = List.generate(7, (i) => List<ClassBlock>());
  }

  Calendar.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ids = HashSet<String>();
//    colors.addAll(CGColors.array);
    List idsList = json['ids'] as List;
    idsList.forEach((id) => ids.add(id));
    final List<dynamic> blocksByDay = json['blocksByDay'];
    this.blocksByDay = List.generate(7, (i) => List<ClassBlock>());
    for (var i = 0; i < blocksByDay.length; ++i) {
      blocksByDay[i].forEach((block) {
        final newBlock = ClassBlock.fromJson(block);
        this.blocksByDay[i].add(newBlock);
//        this.colors.remove((color) => color == newBlock.color);
      });
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
//    colors.removeWhere((c1) {
//      return c1.light.toLowerCase() == color.light.toLowerCase();
//    });
    ids.add(offering.crn);
    for (var classTime in offering.classTimes) {
      final offset = classTime.startTime.hour + classTime.startTime.minute / 60;
      final height = classTime.endTime.hour -
          classTime.startTime.hour +
          (classTime.endTime.minute - classTime.startTime.minute) / 60;
      final departmentInfo =
          course.departmentAcronym + ' ' + course.departmentNumber;
      final block = ClassBlock(
          offset, height, departmentInfo, offering.crn, course.name, color);
      if (classTime.sun) {
        blocksByDay[0].add(block);
      }
      if (classTime.mon) {
        blocksByDay[1].add(block);
      }
      if (classTime.tues) {
        blocksByDay[2].add(block);
      }
      if (classTime.weds) {
        blocksByDay[3].add(block);
      }
      if (classTime.thur) {
        blocksByDay[4].add(block);
      }
      if (classTime.fri) {
        blocksByDay[5].add(block);
      }
      if (classTime.sat) {
        blocksByDay[6].add(block);
      }

    }
  }

  removeOffering(String id) {
//    colors.add(color);
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
