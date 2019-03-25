import 'package:meta/meta.dart';

import 'package:color/color.dart';
import 'package:equatable/equatable.dart';

import 'course.dart';

class SchedulesHistory {

  SchedulesHistory(this.history);

  static SchedulesHistory init({String id}) {
    return SchedulesHistory([Schedules.init(id)]);
  }

  /// History of edits made by user to their schedules
  List<Schedules> history;

  /// Index of current point in history
  int currentHistoryIndex = 0;

  Schedules get current => history[currentHistoryIndex];

  void undo() {
    if (currentHistoryIndex > 0) {
      --currentHistoryIndex;
    }
  }

  void redo() {
    if (currentHistoryIndex < history.length - 1) {
      ++currentHistoryIndex;
    }
  }

  void addSchedule(String name, String id) {
    _addToHistory(current.addSchedule(name, id));
  }

  void editScheduleName(String name) {
    _addToHistory(current.editScheduleName(name));
  }

  void deleteSchedule(String id) {
    _addToHistory(current.deleteSchedule(id));
  }

  void toggleOffering(Offering offering, Color color) {
    _addToHistory(current.toggleOffering(offering, color));
  }

  void _addToHistory(Schedules schedules) {
    history = history.sublist(0, currentHistoryIndex + 1)..add(schedules);
    ++currentHistoryIndex;
  }
}

/// Collection of user's schedules,
class Schedules extends Equatable {
  Schedules({@required this.schedules, this.currentScheduleIndex = 0})
      : super([schedules, currentScheduleIndex]);

  /// List of all user's schedules
  final List<Schedule> schedules;

  /// Index of currently selected schedule
  final int currentScheduleIndex;

  /// Quick access to current schedule
  Schedule get currentSchedule => schedules[currentScheduleIndex];

  static Schedules init(String id) {
    return Schedules(
      schedules: [Schedule.init(id)],
      currentScheduleIndex: 0,
    );
  }

  Schedules deleteSchedule(String id) {
    final List<Schedule> newSchedules = _cloneSchedules()
      ..removeWhere((schedule) => schedule.id == id);
    return Schedules(
      schedules: newSchedules,
      currentScheduleIndex: (newSchedules.length - 1).clamp(0, double.infinity),
    );
  }

  Schedules addSchedule(String name, String id) {
    if (schedules.any((schedule) => schedule.id == id)) {
      throw ArgumentError('A Schedule with id: $id already exsits');
    }
    final List<Schedule> newSchedules = _cloneSchedules()
      ..add(Schedule(name: name, id: id, offerings: {}));
    return Schedules(
      schedules: newSchedules,
      currentScheduleIndex: newSchedules.length - 1,
    );
  }

  Schedules editScheduleName(String name) {
    final List<Schedule> newSchedules = [];
    for (var i = 0; i < schedules.length; ++i) {
      final schedule = schedules[i];
      newSchedules.add(i == currentScheduleIndex
          ? schedule.editScheduleName(name)
          : schedule.clone());
    }
    return Schedules(
      schedules: newSchedules,
      currentScheduleIndex: currentScheduleIndex,
    );
  }

  Schedules toggleOffering(Offering offering, Color color) {
    final List<Schedule> newSchedules = [];
    for (var i = 0; i < schedules.length; ++i) {
      final schedule = schedules[i];
      newSchedules.add(i == currentScheduleIndex
          ? schedule.toggleOffering(offering, color)
          : schedule.clone());
    }
    return Schedules(
      schedules: newSchedules,
      currentScheduleIndex: currentScheduleIndex,
    );
  }

  List<Schedule> _cloneSchedules() {
    return schedules.map((schedule) => schedule.clone()).toList();
  }

  @override
  String toString() =>
      'Schedules{currentScheduleIndex: $currentScheduleIndex, schedules: $schedules}';
}

class Schedule extends Equatable {
  Schedule({@required this.id, this.name, this.offerings})
      : super([name, id, offerings]);

  /// The user-given name for the schedule, i.e. "My New Schedule".
  final String name;

  /// The random generated ID to uniquely identify the schedule in the backend.
  final String id;

  /// Set of offerings including the colors they were saved as.
  final Set<ColoredOffering> offerings;

  /// Default schedule name if user does not supply
  static String defaultScheduleName = 'My Schedule';

  static Schedule init(String id) {
    return Schedule(
      name: defaultScheduleName,
      id: id,
      offerings: {},
    );
  }

  Schedule clone() {
    return Schedule(id: id, name: name, offerings: offerings);
  }

  Schedule editScheduleName(String name) {
    return Schedule(
      offerings: offerings,
      name: name,
      id: id,
    );
  }

  Schedule toggleOffering(Offering offering, Color color) {
    final newOfferings = offerings;
    if (newOfferings.any((co) => co.offering == offering)) {
      newOfferings.removeWhere((co) => co.offering == offering);
    } else {
      newOfferings.add(ColoredOffering(offering: offering, color: color));
    }
    return Schedule(
      offerings: newOfferings,
      name: name,
      id: id,
    );
  }

  // returns map of ids to colors
  Map<String, Color> get colorMap {
    final Map<String, Color> map = {};
    for (final offering in offerings) {
      map[offering.offering.id] = offering.color;
    }
    return map;
  }

  Set<GraphicalClassTime> graphicsForDay(int i) {
    if (i < 0 || i > 6) {
      return null;
    }
    final Set<GraphicalClassTime> graphics = {};
    for (final offering in offerings) {
      for (final classTime
          in offering.offering.classTimes.where((ct) => ct.days[i])) {
        graphics.add(
            GraphicalClassTime(classTime: classTime, color: offering.color));
      }
    }
    return graphics;
  }

  @override
  String toString() => 'Schedule{name: $name, id: $id, offerings: $offerings}';
}

class ColoredOffering {
  ColoredOffering({@required this.offering, @required this.color});
  final Offering offering;
  final Color color;

  @override
  int get hashCode => int.parse(offering.id);
  @override
  bool operator ==(other) {
    return other is ColoredOffering && offering.id == other.offering.id;
  }
}

class GraphicalClassTime {
  GraphicalClassTime({@required this.classTime, @required this.color});
  final ClassTime classTime;
  final Color color;
  double height() =>
      classTime.endTime.hour -
      classTime.startTime.hour +
      (classTime.endTime.minute - classTime.startTime.minute) / 60;

  double offset() => classTime.startTime.hour + classTime.startTime.minute / 60;
}
