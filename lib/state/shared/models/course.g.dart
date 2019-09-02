// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offering _$OfferingFromJson(Map<String, dynamic> json) {
  return Offering(
      name: json['name'] as String,
      deptAcr: json['deptAcr'] as String,
      deptNum: json['deptNum'] as String,
      credit: json['credit'] as String,
      status: _$enumDecodeNullable(_$StatusEnumMap, json['status']),
      id: json['id'] as String,
      teachers: (json['teachers'] as List)?.map((e) => e as String)?.toList(),
      section: json['section'] as String,
      classTimes: (json['classTimes'] as List)
          ?.map((e) =>
              e == null ? null : ClassTime.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      objectID: json['objectID'] as String);
}

Map<String, dynamic> _$OfferingToJson(Offering instance) {
  final val = <String, dynamic>{
    'credit': instance.credit,
    'deptAcr': instance.deptAcr,
    'deptNum': instance.deptNum,
    'name': instance.name,
    'status': _$StatusEnumMap[instance.status],
    'id': instance.id,
    'teachers': instance.teachers,
    'section': instance.section,
    'classTimes': instance.classTimes,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('objectID', instance.objectID);
  return val;
}

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

const _$StatusEnumMap = <Status, dynamic>{
  Status.Open: 'Open',
  Status.Closed: 'Closed',
  Status.Waitlist: 'Waitlist'
};

SearchOffering _$SearchOfferingFromJson(Map<String, dynamic> json) {
  return SearchOffering(
      credit: json['credit'] as String,
      deptAcr: json['deptAcr'] as String,
      deptNum: json['deptNum'] as String,
      name: json['name'] as String,
      status: _$enumDecodeNullable(_$StatusEnumMap, json['status']),
      id: json['id'] as String,
      teachers: (json['teachers'] as List)?.map((e) => e as String)?.toList(),
      section: json['section'] as String,
      classTimes: (json['classTimes'] as List)
          ?.map((e) =>
              e == null ? null : ClassTime.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      deptNumInt: json['deptNumInt'] as int,
      sectionInt: json['sectionInt'] as int,
      range: json['range'] == null
          ? null
          : ClassTime.fromJson(json['range'] as Map<String, dynamic>),
      deptName: json['deptName'] as String,
      school: json['school'] as String,
      season: json['season'] as String);
}

Map<String, dynamic> _$SearchOfferingToJson(SearchOffering instance) =>
    <String, dynamic>{
      'credit': instance.credit,
      'deptAcr': instance.deptAcr,
      'deptNum': instance.deptNum,
      'name': instance.name,
      'status': _$StatusEnumMap[instance.status],
      'id': instance.id,
      'teachers': instance.teachers,
      'section': instance.section,
      'classTimes': instance.classTimes,
      'deptNumInt': instance.deptNumInt,
      'sectionInt': instance.sectionInt,
      'deptName': instance.deptName,
      'range': instance.range,
      'school': instance.school,
      'season': instance.season
    };

ClassTime _$ClassTimeFromJson(Map<String, dynamic> json) {
  return ClassTime(
      location: json['location'] as String,
      u: json['u'] as bool,
      m: json['m'] as bool,
      t: json['t'] as bool,
      w: json['w'] as bool,
      r: json['r'] as bool,
      f: json['f'] as bool,
      s: json['s'] as bool,
      end: json['end'] == null
          ? null
          : TimeOfDay.fromTimestamp(json['end'] as int),
      start: json['start'] == null
          ? null
          : TimeOfDay.fromTimestamp(json['start'] as int));
}

Map<String, dynamic> _$ClassTimeToJson(ClassTime instance) => <String, dynamic>{
      'location': instance.location,
      'u': instance.u,
      'm': instance.m,
      't': instance.t,
      'w': instance.w,
      'r': instance.r,
      'f': instance.f,
      's': instance.s,
      'start':
          instance.start == null ? null : TimeOfDay.toTimestamp(instance.start),
      'end': instance.end == null ? null : TimeOfDay.toTimestamp(instance.end)
    };
