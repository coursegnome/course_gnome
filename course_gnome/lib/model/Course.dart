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
}

class Offering {
  String sectionNumber, status, crn, instructors;
  List<ClassTime> classTimes;
  List<Offering> linkedOfferings;

  Offering({
    this.sectionNumber,
    this.status,
    this.crn,
    this.classTimes,
    this.instructors,
    this.linkedOfferings,
  });
}

class ClassTime {
  TimeOfDay startTime, endTime;
  String location;
  List<bool> days;

  ClassTime({
    this.startTime,
    this.endTime,
    this.location,
    this.days,
  });

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
