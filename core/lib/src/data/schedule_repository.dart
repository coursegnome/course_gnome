import 'dart:convert';
import 'package:http/http.dart';
import 'package:core/core.dart';
import 'package:color/color.dart';
import 'package:algolia/algolia.dart';
import 'config.dart' as algolia_config;

class ScheduleRepository {
  Future<Schedules> getAllSchedules() async {
    final List<Schedule> scheduleList = [];
    final List<String> ids = ['2'];
    //for (final scheduleJson in allSchedules.entries) {
//    scheduleList.add(Schedule(
//      id: scheduleJson.keys.first,
//      name: scheduleJson.values.first['name'],
//      offerings: List
//    ));
    //for (final offering in scheduleJson.values.first['offerings'].entries) {
    //  ids.add(offering.key);
    //}
    //}
    final List<Offering> courses = [];
    print(ids);
    if (ids.isNotEmpty) {
      const index = 'gwu-201902';
      const Algolia algolia = Algolia.init(
        applicationId: '4AISU681XR',
        apiKey: algolia_config.apiKey,
      );
      final String query = 'offerings.crn=${ids.first}';
      for (var i = 0; i < ids.length; ++i) {}
      AlgoliaQuery _algQuery = algolia.instance.index(index);
      _algQuery = _algQuery
          .setFacetFilter(['offerings.crn:10099', 'offerings.crn:10912']);
      print(_algQuery.parameters);
      final AlgoliaQuerySnapshot _snap = await _algQuery.getObjects();
      print(_snap.hits[1].data);
    }
  }

  Future<String> addSchedule({String scheduleName}) async {}
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
