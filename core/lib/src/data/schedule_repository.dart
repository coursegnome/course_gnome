import 'dart:convert';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:color/color.dart';
import 'package:algolia/algolia.dart';
import 'config.dart' as algolia_config;

// These callbacks allow web and native to handle firebase work.
typedef GetAllSchedules = Future<Map<String, dynamic>> Function();
typedef AddSchedule = Future<String> Function({String scheduleName});
typedef DeleteSchedule = Future<void> Function({String scheduleId});
typedef EditSchedule = Future<void> Function(
    {String scheduleId, Map<String, Color> offerings});

class ScheduleRepository {
  ScheduleRepository({
    this.getAllSchedulesCallback,
    this.addSchedule,
    this.deleteSchedule,
    this.editScheduleCallback,
  });
 
  final GetAllSchedules getAllSchedulesCallback;
  final AddSchedule addSchedule;
  final DeleteSchedule deleteSchedule;
  final EditSchedule editScheduleCallback;

  Future<Schedules> getAllSchedules() async {
    if (getAllSchedulesCallback == null) {
      //   return null;
    }

    //final Map<String, dynamic> allSchedules = await getAllSchedulesCallback();
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
    final List<Course> courses = [];
    print(ids);
    if (ids.isNotEmpty) {
      const index = 'gwu-201902';
      const Algolia algolia = Algolia.init(
        applicationId: '4AISU681XR',
        apiKey: algolia_config.apiKey,
      );
      final String query = 'offerings.crn=${ids.first}';
      for (var i = 0; i < ids.length; ++i) {}
      final AlgoliaQuery _algQuery = algolia.instance.index(index);
      _algQuery.setFacetFilter('crn:10732');
      print(_algQuery.parameters);
      final AlgoliaQuerySnapshot _snap = await _algQuery.getObjects();
      print(_snap.hits.first.data);
    }
  }

  Future<void> updateSchedule({
    @required String scheduleId,
    @required Map<String, Color> offerings,
  }) async {
    // colors to strings
    if (editScheduleCallback == null) {
      return;
    }
    Map<String, String> stringOfferings;
    for (final entry in offerings.entries) {
      stringOfferings[entry.key] = entry.value.toString();
    }
    editScheduleCallback(scheduleId: scheduleId, offerings: offerings);
  }
}
