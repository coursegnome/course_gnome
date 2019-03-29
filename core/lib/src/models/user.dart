import 'package:json_annotation/json_annotation.dart';
import 'package:core/core.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.school,
    this.displayName,
    this.username,
    this.id,
    this.photoUrl,
    this.email,
    this.emailVerified,
    this.createdAt,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  @JsonKey(name: 'localId')
  String id;
  String school, displayName, username, photoUrl, email;
  bool emailVerified;
  @JsonKey(fromJson: _fromJson)
  DateTime createdAt;
  @JsonKey(ignore: true)
  SchedulesHistory schedulesHistory;
  bool get isStudent => this is Student;

  static DateTime _fromJson(String millis) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(millis));
  }
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
