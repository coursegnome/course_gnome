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

  Map<String, dynamic> toJson() => {
    'departmentAcronym': departmentAcronym,
    'departmentNumberString': departmentNumber,
    'departmentNumber': int.parse(departmentNumber.replaceAll(RegExp('[^0-9]'), '')),
    'name': name,
    'credit': credit,
    'description': description,
    'bulletinLink': bulletinLink,
    'offerings': List.generate(offerings.length, ((i) => offerings[i].toJson()))
  };


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
  String comments;
  List<String> courseAttributes;
  String findBooksLink;
  String fee;

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
    return 'Offering{sectionNumber: $sectionNumber, crn: $crn, '
        'instructors: $instructors, status: $status, classTimes: $classTimes, '
        'linkedOfferings: $linkedOfferings, linkedOfferingsName: $linkedOfferingsName, '
        'comments: $comments, courseAttributes: $courseAttributes, '
        'findBooksLink: $findBooksLink, fee: $fee}';
  }

  Map<String, dynamic> toJson() => {
    'sectionNumber': sectionNumber,
    'crn': crn,
    'instructors': instructors,
    'status': status.toString().split('.').last,
    'classTimes': List.generate(classTimes.length, ((i) => classTimes[i].toJson())),
    'linkedOfferings': linkedOfferings != null ? List.generate(linkedOfferings.length, ((i) => linkedOfferings[i].toJson())) : null,
    'linkedOfferingsName': linkedOfferingsName,
    'comments': comments,
    'courseAttributes': courseAttributes,
    'findBooksLink': findBooksLink,
    'fee': fee,
  };

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

  Map<String, dynamic> toJson() => {
  'startTime': startTime != null ? startTime.toTimestamp() : null,
  'endTime': endTime != null ? endTime.toTimestamp() : null,
  'location': location,
  'sun': sun,
  'mon': mon,
  'tues': tues,
  'weds': weds,
  'thur': thur,
  'fri': fri,
  'sat': sat
  };

  String timeToString(TimeOfDay time) {
    var minuteString = time.minute.toString();
    if (time.minute < 10) {
      minuteString += '0';
    }
    final hourString = ((time.hour - 1) % 12 + 1).toString();
    return hourString + ':' + minuteString;
  }

  String timeRangeToString() {
    if (startTime == null || endTime == null) {
      return 'TBA';
    }
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

  toTimestamp() {
    final date = DateTime(2000, 1, 1, hour, minute);
    return date.toIso8601String();
  }
}
