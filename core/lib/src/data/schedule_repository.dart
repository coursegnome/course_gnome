import 'dart:convert';
import 'package:core/core.dart';
import 'package:color/color.dart';
import 'package:algolia/algolia.dart';
import 'http_wrapper.dart';
import 'config.dart';

class ScheduleRepository {
  ScheduleRepository({this.userRepository, this.school, this.season});
  final UserRepository userRepository;
  School school = School.gwu;
  Season season = Season.fall2019;
  SchedulesHistory schedulesHistory;

  Future<Schedules> getAllSchedules() async {
    final List<Schedule> schedules = [];
    final List<String> ids = ['2'];
    final List<Map> scheduleMaps = await getDocs(
      idToken: await userRepository.idToken,
      path: 'users/${userRepository.uid}/${school.id}',
    );
    if (scheduleMaps == null) {
      return null;
    }
    for (final schedule in scheduleMaps) {
      schedule.values.first['offerings'].entries;
    }
    for (final scheduleJson in scheduleMaps) {
      schedules.add(
        Schedule(
          id: scheduleJson.keys.first,
          name: scheduleJson.values.first['name'],
        ),
      );
    }
    if (ids.isNotEmpty) {
      const index = 'gwu-201902';
      for (var i = 0; i < ids.length; ++i) {}
      final AlgoliaIndexReference _index = algolia.instance.index(index);
      //final AlgoliaQuerySnapshot _snap = await _index.getObjects(['ee']);
     // print(_snap.hits[1].data);
    }
  }

  void switchSchool(School school) {
    school = school;
  }

  Future<String> addSchedule({String scheduleName}) async {
    return await createDoc(
        idToken: await userRepository.idToken,
        path: 'users/${userRepository.uid}/${school.id}',
        fields: <String, dynamic>{
          'name': scheduleName,
          'offerings': <String, dynamic>{},
        });
  }

  Future<void> deleteSchedule({String scheduleId}) async {}
  Future<void> updateSchedule({String name}) async {}
/*
  Future<void> updateSchedule({
    String scheduleId,
    String name,
    Map<String, Color> offerings,
  }) async {
    // colors to strings
    if (updateScheduleCallback == null) {
      return;
    }
    Map<String, String> stringOfferings;
    for (final entry in offerings.entries) {
      stringOfferings[entry.key] = entry.value.toString();
    }
    updateScheduleCallback(scheduleId: scheduleId, offerings: offerings);
  }*/
}
