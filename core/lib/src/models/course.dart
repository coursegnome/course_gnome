import 'package:meta/meta.dart';

class Course {
  Course({
    @required this.departmentAcronym,
    @required this.departmentNumber,
    @required this.name,
    @required this.offerings,
    this.credit,
    this.description,
    this.bulletinLink,
  });

  final String departmentAcronym,
      departmentNumber,
      name,
      credit,
      description,
      bulletinLink;
  final List<Offering> offerings;

  @override
  String toString() {
    return 'Course{departmentAcronym: $departmentAcronym, '
        'departmentNumber: $departmentNumber, name: $name, credit: $credit, '
        'description: $description, bulletinLink: $bulletinLink, '
        'offerings: $offerings}';
  }

  static Course fromJson(Map<String, dynamic> json) {
    final List<Offering> offerings = json['offerings']
        .map((Map<String, dynamic> item) => Offering.fromJson(item))
        .toList();
    return Course(
        departmentAcronym: json['departmentAcronym'],
        departmentNumber: json['departmentNum'],
        name: json['name'],
        credit: json['credit'],
        description: json['description'],
        bulletinLink: json['bulletinLink'],
        offerings: offerings);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'departmentAcronym': departmentAcronym,
        'departmentNumberString': departmentNumber,
        'departmentNumber':
            int.parse(departmentNumber.replaceAll(RegExp('[^0-9]'), '')),
        'name': name,
        'credit': credit,
        'description': description,
        'bulletinLink': bulletinLink,
        'offerings': offerings.map((Offering o) => o.toJson()).toList(),
      };
}

enum Status { Open, Closed, Waitlist }

class Offering {
  Offering({
    @required this.status,
    @required this.sectionNumber,
    @required this.crn,
    this.instructors,
    this.courseAttributes,
    this.classTimes,
    this.linkedOfferings,
    this.linkedOfferingsName,
    this.comments,
    this.findBooksLink,
    this.fee,
    this.days,
    this.earliestStartTime,
    this.latestEndTime,
  })  : assert(status != null),
        assert(sectionNumber != null),
        assert(crn != null);

  final List<String> instructors, courseAttributes;
  final List<ClassTime> classTimes;
  final List<Offering> linkedOfferings;
  final Status status;
  final String sectionNumber,
      crn,
      linkedOfferingsName,
      comments,
      findBooksLink,
      fee;
  final TimeOfDay earliestStartTime, latestEndTime;
  final List<bool> days;

  @override
  String toString() {
    return 'Offering{sectionNumber: $sectionNumber, crn: $crn, '
        'instructors: $instructors, status: $status, classTimes: $classTimes, '
        'linkedOfferings: $linkedOfferings, linkedOfferingsName: $linkedOfferingsName, '
        'comments: $comments, courseAttributes: $courseAttributes, '
        'findBooksLink: $findBooksLink, fee: $fee, days: $days, '
        'earliestStartTime: $earliestStartTime, latestEndTime: $latestEndTime}';
  }

  static Offering fromJson(Map<String, dynamic> json) {
    final List<ClassTime> classTimes = json['classTimes']
        .map((Map<String, dynamic> item) => ClassTime.fromJson(item))
        .toList();
    final List<Offering> linkedOfferings = json['linkedOfferings']
        .map((Map<String, dynamic> item) => Offering.fromJson(item))
        .toList();
    final Status status = json['status'] == 'Open'
        ? Status.Open
        : json['status'] == 'Closed' ? Status.Closed : Status.Waitlist;
    return Offering(
      instructors: json['instructors'],
      courseAttributes: json['courseAttributes'],
      classTimes: classTimes,
      linkedOfferings: linkedOfferings,
      status: status,
      sectionNumber: json['sectionNumber'],
      crn: json['crn'],
      linkedOfferingsName: json['linkedOfferingsName'],
      comments: json['comments'],
      findBooksLink: json['findBooksLink'],
      days: json['fee'],
      earliestStartTime: TimeOfDay.fromTimestamp(json['earliestStartTime']),
      latestEndTime: TimeOfDay.fromTimestamp(json['latestEndTime']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sectionNumber': sectionNumber,
        'crn': crn,
        'instructors': instructors,
        'status': status.toString().split('.').last,
        'classTimes': classTimes?.map((ClassTime ct) => ct.toJson())?.toList(),
        'linkedOfferings':
            linkedOfferings?.map((Offering o) => o.toJson())?.toList(),
        'linkedOfferingsName': linkedOfferingsName,
        'comments': comments,
        'courseAttributes': courseAttributes,
        'findBooksLink': findBooksLink,
        'fee': fee,
        'days': days,
        'earliestStartTime': earliestStartTime?.timestamp,
        'latestEndTime': latestEndTime?.timestamp,
      };
}

class ClassTime {
  ClassTime({
    this.startTime,
    this.endTime,
    this.days,
    this.location,
  });

  final TimeOfDay startTime, endTime;
  final List<bool> days;
  final String location;

  @override
  String toString() {
    return 'ClassTime{$timeRange, location: $location, sun: ${days[0]}, '
        'mon: ${days[1]}, tues: ${days[2]}, weds: ${days[3]}, thur: ${days[4]}, '
        'fri: ${days[5]}, sat: ${days[6]}}';
  }

  static ClassTime fromJson(Map<String, dynamic> json) {
    return ClassTime(
      startTime: TimeOfDay.fromTimestamp(json['startTime']),
      endTime: TimeOfDay.fromTimestamp(json['endTime']),
      location: json['location'],
      days: json['days'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'startTime': startTime?.timestamp,
        'endTime': endTime?.timestamp,
        'location': location,
        'days': days,
      };

  String get timeRange {
    if (startTime == null || endTime == null) {
      return 'TBA';
    }
    return startTime.toString() + '-' + endTime.toString();
  }
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

  final int hour, minute;

  /// Returns a [String] timestamp for the given time on January 1st, 2000.
  String get timestamp => DateTime(2000, 1, 1, hour, minute).toIso8601String();

  @override
  String toString() {
    String minuteString = minute.toString();
    if (minute < 10) {
      minuteString += '0';
    }
    final String hourString = ((hour - 1) % 12 + 1).toString();
    return hourString + ':' + minuteString;
  }

  bool operator <(TimeOfDay time) =>
      hour < time.hour || (hour == time.hour && minute < time.minute);

  @override
  bool operator ==(dynamic other) {
    return other is TimeOfDay && hour == other.hour && minute == other.minute;
  }

  @override
  int get hashCode => hour * 60 + minute;

  /// Parses a [TimeOfDay] from a properly formatted [String] timestamp,
  /// such as `2012-02-27 13:27:00`;
  static TimeOfDay fromTimestamp(String timestamp) {
    final DateTime date = DateTime.parse(timestamp);
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }
}
