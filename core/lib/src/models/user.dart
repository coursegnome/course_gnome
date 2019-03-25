import 'package:core/core.dart';

class User {
  String school, displayName, username, uid, photoUrl, email;
  bool isAnonymous, isVerified;
  SchedulesHistory schedulesHistory;
  
  bool get isStudent => this is Student;
}

class Student extends User {
  int year;
  List<String> advisors;
}

class Advisor extends User {
  List<Advisee> advisees;
}

class Advisee {
  String uid;
  List<String> schedules;
}
