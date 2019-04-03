import 'package:json_annotation/json_annotation.dart';
import 'package:core/core.dart';
part 'user.g.dart';

enum UserType { Student, Advisor }

abstract class User {
  User({
    this.userType,
    this.school,
    this.displayName,
    this.username,
    this.photoUrl,
    this.email,
    this.emailVerified,
  });
  final UserType userType;
  final School school;
  final String displayName, username, photoUrl, email;
  final bool emailVerified;
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class Student extends User {
  Student({
    this.year,
    this.advisors,
    UserType userType,
    School school,
    String displayName,
    String username,
    String photoUrl,
    String email,
    bool emailVerified,
  })  : assert(year < 5 && year > 0),
        super(
          userType: userType,
          school: school,
          displayName: displayName,
          username: username,
          photoUrl: photoUrl,
          email: email,
          emailVerified: emailVerified,
        );

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$StudentToJson(this);

  final int year;
  final List<String> advisors;
}

@JsonSerializable()
class Advisor extends User {
  Advisor({
    this.advisees,
    UserType userType,
    School school,
    String displayName,
    String username,
    String photoUrl,
    String email,
    bool emailVerified,
  }) : super(
          userType: userType,
          school: school,
          displayName: displayName,
          username: username,
          photoUrl: photoUrl,
          email: email,
          emailVerified: emailVerified,
        );

  factory Advisor.fromJson(Map<String, dynamic> json) =>
      _$AdvisorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AdvisorToJson(this);

  final List<Advisee> advisees;
}

@JsonSerializable()
class Advisee {
  Advisee({this.uid, this.schedules});
  factory Advisee.fromJson(Map<String, dynamic> json) =>
      _$AdviseeFromJson(json);
  Map<String, dynamic> toJson() => _$AdviseeToJson(this);
  final String uid;
  final List<String> schedules;
}
