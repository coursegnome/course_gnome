import 'package:course_gnome/model/UtilityClasses.dart';

class Course {
  String departmentAcronym,
      departmentNumber,
      name,
      credit,
      description,
      bulletinLink;
  List<Offering> offerings;

  Course({
    this.departmentAcronym,
    this.departmentNumber,
    this.name,
    this.credit,
    this.description,
    this.bulletinLink,
    this.offerings,
  });

  @override
  String toString() {
    return 'Course{departmentAcronym: $departmentAcronym, '
        'departmentNumber: $departmentNumber, name: $name, credit: $credit, '
        'description: $description, bulletinLink: $bulletinLink, '
        'offerings: $offerings}';
  }

}

enum Status {
  Open, Closed, Waitlist
}

class Offering {
  String sectionNumber, crn;
  List<String> instructors;
  Status status;
  List<ClassTime> classTimes;
  List<Offering> linkedOfferings;
  String linkedOfferingsName;

  Offering({
    this.sectionNumber,
    this.status,
    this.crn,
    this.classTimes,
    this.instructors,
    this.linkedOfferings,
    this.linkedOfferingsName,
  });

  @override
  String toString() {
    return 'Offering(sectionNumber: $sectionNumber, status: $status,'
        'crn: $crn, classTimes: $classTimes, instructors: $instructors,'
        'linkedOfferings: $linkedOfferings, '
        'linkedOfferingsName: $linkedOfferingsName)';
  }
}

class ClassTime {
  TimeOfDay startTime, endTime;
  String location;
  bool sun;
  bool mon;
  bool tues;
  bool weds;
  bool thur;
  bool fri;
  bool sat;

  ClassTime({
    this.startTime,
    this.endTime,
    this.location,
  });


  @override
  String toString() {
    return 'ClassTime{${timeRangeToString()}, location: $location, sun: $sun, '
        'mon: $mon, tues: $tues, weds: $weds, thur: $thur, fri: $fri, sat: $sat}';
  }

  String timeToString(TimeOfDay time) {
    var minuteString = time.minute.toString();
    if (time.minute < 10) {
      minuteString += '0';
    }
    final hourString = ((time.hour - 1) % 12 + 1).toString();
    return hourString + ':' + minuteString;
  }

  String timeRangeToString() {
    return timeToString(startTime) + '-' + timeToString(endTime);
  }
}

class TimeOfDay {
  final int hour, minute;
  TimeOfDay({this.hour, this.minute});
  @override
  String toString() {
    return '$hour:$minute';
  }
}
