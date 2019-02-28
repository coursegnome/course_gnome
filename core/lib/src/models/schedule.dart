import 'dart:collection';
import 'dart:convert';

import 'package:color/color.dart';

import 'course.dart';

class SchedulesHistory {
  int current = 0;
  List<Schedules> history = [];

  void update(Schedules schedules) {
    history = history.sublist(0, current);
    history.add(schedules);
    current = history.length - 1;
  }

  Schedules goBackwards() {
    if (current != 0) {
      --current;
    }
    return history[current];
  }

  Schedules goForwards() {
    if (current != history.length - 1) {
      ++current;
    }
    return history[current];
  }
}

class Schedules {
  factory Schedules(String jsonString) {
    if (jsonString == null) {
      return Schedules._internal()..addSchedule(initialScheduleName);
    }
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Schedules.fromJson(json);
  }

  Schedules._internal({this.currentScheduleIndex, this.list});

  static Schedules fromJson(Map<String, dynamic> json) {
    final List<Schedule> list = json['classTimes']
        .map((Map<String, dynamic> schedule) => Schedule.fromJson(schedule))
        .toList();
    return Schedules._internal(
      currentScheduleIndex: json['currentScheduleIndex'],
      list: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'list': list,
        'currentScheduleIndex': currentScheduleIndex,
      };

  static const String initialScheduleName = 'My Schedule';
  int currentScheduleIndex;
  List<Schedule> list = [];
  Schedule get currentSchedule => list[currentScheduleIndex];

  void addSchedule(String name) {
    final schedule = Schedule(name);
    list.add(schedule);
    currentScheduleIndex = list.length - 1;
  }

  void removeSchedule(Schedule schedule) {
    list.remove(schedule);
  }
}

class Schedule {
  Schedule(this.name, this.id, {this.offerings, this.colors});

  static Schedule fromJson(Map<String, dynamic> json) {
    final List<Offering> offerings = json['offerings']
        .map((Map<String, dynamic> offering) => Offering.fromJson(offering))
        .toList();
    return Schedule(json['name'], json['id'],
        offerings: offerings, colors: json['colors']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'ids': offerings,
        'colors': colors,
      };

  String name, id;
  List<Offering> offerings;
  Map<String, Color> colors; // map ids to colors

  HashSet<String> get ids => offerings.map((o) => o.crn).toSet();

  double height(ClassTime classTime) {
    return classTime.endTime.hour -
        classTime.startTime.hour +
        (classTime.endTime.minute - classTime.startTime.minute) / 60;
  }

  double offset(ClassTime classTime) =>
      classTime.startTime.hour + classTime.startTime.minute / 60;

  List<ClassTime> classTimesForDay(int i) {
    final List<ClassTime> classTimes = [];
    for (final offering in offerings) {
      classTimes.addAll(offering.classTimes.where((ct) => ct.days[i]));
    }
    return classTimes;
  }

  void toggleOffering(Course course, Offering offering, Color color) {
    if (ids.contains(offering.crn)) {
      removeOffering(offering.crn);
    } else {
      addOffering(course, offering, color);
    }
  }

  void addOffering(Course course, Offering offering, Color color) {
    offerings.add(offering);
    colors[offering.crn] = color;
  }

  void removeOffering(String id) {
    ids.remove(id);
    colors.remove(id);
  }
}
