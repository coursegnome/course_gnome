import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Offering {
  Offering({
    this.name,
    this.deptAcr,
    this.deptNum,
    this.credit,
    this.status,
    this.id,
    this.teachers,
    this.section,
    this.classTimes,
    this.objectID,
  });
  factory Offering.fromJson(Map<String, dynamic> json) =>
      _$OfferingFromJson(json);
  final String credit;
  final String deptAcr;
  final String deptNum;
  final String name;
  final Status status;
  final String id;
  final List<String> teachers;
  final String section;
  final List<ClassTime> classTimes;
  @JsonKey(includeIfNull: false)
  final String objectID;

  bool inSameClassAs(Offering offering) =>
      name == offering.name &&
      deptAcr == offering.deptAcr &&
      deptNum == offering.deptNum;
}

@JsonSerializable()
class SearchOffering extends Offering {
  SearchOffering({
    String credit,
    String deptAcr,
    String deptNum,
    String name,
    Status status,
    String id,
    List<String> teachers,
    String section,
    List<ClassTime> classTimes,
    this.deptNumInt,
    this.sectionInt,
    this.range,
    this.deptName,
    this.school,
    this.season,
  }) : super(
          name: name,
          deptAcr: deptAcr,
          deptNum: deptNum,
          credit: credit,
          status: status,
          id: id,
          teachers: teachers,
          section: section,
          classTimes: classTimes,
        );
  Map<String, dynamic> toJson() => _$SearchOfferingToJson(this);
  final int deptNumInt;
  final int sectionInt;
  final String deptName;
  final ClassTime range;
  final String school;
  final String season;
}

@JsonSerializable()
class ClassTime {
  ClassTime({
    this.location,
    this.u,
    this.m,
    this.t,
    this.w,
    this.r,
    this.f,
    this.s,
    this.end,
    this.start,
  });
  factory ClassTime.fromJson(Map<String, dynamic> json) =>
      _$ClassTimeFromJson(json);
  Map<String, dynamic> toJson() => _$ClassTimeToJson(this);
  final String location;
  final bool u, m, t, w, r, f, s;
  List<bool> get days => [u, m, t, w, r, f, s];
  bool get timeIsTBA {
    for (bool day in days) {
      if (day == null) {
        return true;
      }
    }
    return false;
  }

  @JsonKey(fromJson: TimeOfDay.fromTimestamp, toJson: TimeOfDay.toTimestamp)
  final TimeOfDay start;
  @JsonKey(fromJson: TimeOfDay.fromTimestamp, toJson: TimeOfDay.toTimestamp)
  final TimeOfDay end;
  String get timeRange {
    if (start == null || end == null) {
      return 'TBA';
    }
    return start.toString() + '-' + end.toString();
  }
}

enum Status { Open, Closed, Waitlist }

class School {
  const School._(this.id, this.domain);
  String toJson() => id;
  factory School.fromJson(String id) {
    switch (id) {
      case 'gwu':
        return gwu;
      default:
        return null;
    }
  }
  final String id;
  final String domain;
//  final dynamic k = GwuSeason.values;
  static const all = [gwu];
  static const gwu = School._('gwu', 'gwmail.gwu.edu');
}

enum GwuSeason { Summer2019, Fall2019 }

class Season {
  const Season._(this.id);
  final String id;
  static const all = [summer2019, fall2019];
  static const summer2019 = Season._('summer2019');
  static const fall2019 = Season._('fall2019 ');
}

class TimeOfDay {
  /// A timestamp made up of an hour and a minute value.
  ///
  /// Uses 24 hour time. Defaults to midnight if no parameters are passed in.
  TimeOfDay({
    this.hour = 0,
    this.minute = 0,
  })  : assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59);

  static TimeOfDay fromTimestamp(int timestamp) {
    final int hour = (timestamp / 60).floor();
    final int minute = timestamp == 0 ? 0 : timestamp % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int toTimestamp(TimeOfDay timeOfDay) => timeOfDay.timestamp;

  final int hour, minute;

  /// Returns a [int] timestamp that represens the time in minutes
  int get timestamp => hour * 60 + minute;

  @override
  String toString() {
    String minuteString = minute.toString();
    if (minute < 10) {
      minuteString = '0' + minuteString;
    }
    final String hourString = ((hour - 1) % 12 + 1).toString();
    return hourString + ':' + minuteString;
  }

  bool operator <(TimeOfDay time) => timestamp < time.timestamp;

  @override
  bool operator ==(dynamic other) {
    return other is TimeOfDay && timestamp == other.timestamp;
  }

  @override
  int get hashCode => timestamp;
}
