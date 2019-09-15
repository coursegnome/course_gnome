import 'package:equatable/equatable.dart';

import 'package:course_gnome_data/models.dart';

class Query extends Equatable {
  Query({
    this.school,
    this.season,
    this.text,
    this.departments,
    this.statuses,
    this.minDepartmentNumber,
    this.maxDepartmentNumber,
    this.earliestStartTime,
    this.latestEndTime,
    this.u,
    this.m,
    this.t,
    this.w,
    this.r,
    this.f,
    this.s,
  }) : super(<dynamic>[
          text,
          departments,
          statuses,
          minDepartmentNumber,
          maxDepartmentNumber,
          earliestStartTime,
          latestEndTime,
          u,
          m,
          t,
          w,
          r,
          f,
          s,
        ]);

  Query.initial()
      : school = School.gwu,
        // : school = null,
        season = Season.fall2019,
        // season = null,
        text = '',
        departments = const [],
        statuses = const [],
        minDepartmentNumber = 1000,
        maxDepartmentNumber = 10000,
        earliestStartTime = TimeOfDay.min,
        latestEndTime = TimeOfDay.max,
        this.u = false,
        this.m = false,
        this.t = false,
        this.w = false,
        this.r = false,
        this.f = false,
        this.s = false;

  // School and season
  final School school;
  final Season season;

  // search text
  final String text;

  //facets
  final List<String> departments;
  final List<Status> statuses;

  // numeric
  final int minDepartmentNumber, maxDepartmentNumber;
  final TimeOfDay earliestStartTime, latestEndTime;
  final bool u, m, t, w, r, f, s;

  List<bool> get days => [u, m, t, w, r, f, s];
  static const dayStrings = ['u', 'm', 't', 'w', 'r', 'f', 's'];

  bool get isEmpty =>
      text == '' &&
      departments.isEmpty &&
      statuses.isEmpty &&
      minDepartmentNumber == 1000 &&
      maxDepartmentNumber == 10000 &&
      earliestStartTime == TimeOfDay.min &&
      latestEndTime == TimeOfDay.max &&
      days.every((day) => day == false);

  @override
  String toString() {
    return '''School: $school, season: $season, department: $departments, 
    text: $text, statuses: $statuses, minDepNum: $minDepartmentNumber, 
    maxDepNum: $maxDepartmentNumber, earliestTime:$earliestStartTime, latestTime: $latestEndTime,
    days: $days,
    ''';
  }
}
