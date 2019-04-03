// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) {
  return Student(
      year: json['year'] as int,
      advisors: (json['advisors'] as List)?.map((e) => e as String)?.toList(),
      userType: _$enumDecodeNullable(_$UserTypeEnumMap, json['userType']),
      school: json['school'] == null
          ? null
          : School.fromJson(json['school'] as String),
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      photoUrl: json['photoUrl'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool);
}

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'userType': _$UserTypeEnumMap[instance.userType],
      'school': instance.school,
      'displayName': instance.displayName,
      'username': instance.username,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'year': instance.year,
      'advisors': instance.advisors
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$UserTypeEnumMap = <UserType, dynamic>{
  UserType.Student: 'Student',
  UserType.Advisor: 'Advisor'
};

Advisor _$AdvisorFromJson(Map<String, dynamic> json) {
  return Advisor(
      advisees: (json['advisees'] as List)
          ?.map((e) =>
              e == null ? null : Advisee.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      userType: _$enumDecodeNullable(_$UserTypeEnumMap, json['userType']),
      school: json['school'] == null
          ? null
          : School.fromJson(json['school'] as String),
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      photoUrl: json['photoUrl'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool);
}

Map<String, dynamic> _$AdvisorToJson(Advisor instance) => <String, dynamic>{
      'userType': _$UserTypeEnumMap[instance.userType],
      'school': instance.school,
      'displayName': instance.displayName,
      'username': instance.username,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'advisees': instance.advisees
    };

Advisee _$AdviseeFromJson(Map<String, dynamic> json) {
  return Advisee(
      uid: json['uid'] as String,
      schedules:
          (json['schedules'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$AdviseeToJson(Advisee instance) =>
    <String, dynamic>{'uid': instance.uid, 'schedules': instance.schedules};
