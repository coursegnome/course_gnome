import 'package:course_gnome/state/shared/models/course.dart';
import 'package:equatable/equatable.dart';

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
    this.u = false,
    this.m = false,
    this.t = false,
    this.w = false,
    this.r = false,
    this.f = false,
    this.s = false,
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
      text == null &&
      departments == null &&
      statuses == null &&
      minDepartmentNumber == null &&
      maxDepartmentNumber == null &&
      earliestStartTime == null &&
      latestEndTime == null &&
      days.every((day) => day == false);
}
