// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      school: json['school'] as String,
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      id: json['localId'] as String,
      photoUrl: json['photoUrl'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
      createdAt: json['createdAt'] == null
          ? null
          : User._fromJson(json['createdAt'] as String));
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'localId': instance.id,
      'school': instance.school,
      'displayName': instance.displayName,
      'username': instance.username,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'createdAt': instance.createdAt?.toIso8601String()
    };
