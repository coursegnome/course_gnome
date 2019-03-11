import 'dart:convert';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:color/color.dart';
import 'package:algolia/algolia.dart';
import 'config.dart' as algolia_config;

const addScheduleUrl =
    'https://us-central1-course-gnome.cloudfunctions.net/addSchedule';
const deleteScheduleUrl =
    'https://us-central1-course-gnome.cloudfunctions.net/deleteSchedule';
const allSchedulesUrl =
    'https://us-central1-course-gnome.cloudfunctions.net/allSchedules';
const updateScheduleUrl =
    'https://us-central1-course-gnome.cloudfunctions.net/updateSchedule';

////    final Map<String, dynamic> json = jsonDecode(response.body);

Future<Schedules> allSchedules({String userId}) async {
  http.Response response;
  try {
    response = await http.post(allSchedulesUrl, body: {'userId': userId});
    print(response.request);
  } catch (e) {
    print(e);
    throw ScheduleLoadError('Failed to load schedules');
  }
  final List<dynamic> schedulesJson = json.decode(response.body);
  final List<Schedule> scheduleList = [];
  final List<String> ids = [];
  for (final scheduleJson in schedulesJson) {
//    scheduleList.add(Schedule(
//      id: scheduleJson.keys.first,
//      name: scheduleJson.values.first['name'],
//      offerings: List
//    ));
    for (final offering in scheduleJson.values.first['offerings'].entries) {
      ids.add(offering.key);
    }
  }
  final List<Course> courses = [];
  print(ids);
  if (ids.isNotEmpty) {
    const index = 'gwu-201902';
    const Algolia algolia = Algolia.init(
        applicationId: '4AISU681XR', apiKey: algolia_config.apiKey);
    final String query = 'offerings.crn=${ids.first}';
    for (var i = 0; i < ids.length; ++i) {}
    final AlgoliaQuery _algQuery = algolia.instance.index(index);
    _algQuery.setFacetFilter('crn:10732');
    final AlgoliaQuerySnapshot _snap = await _algQuery.getObjects();
    print(_snap.hits.first.data);
  }
}

Future<String> addSchedule({
  @required String userId,
  @required String scheduleName,
}) async {
  final response = await http.post(
    addScheduleUrl,
    body: {
      'userId': userId,
      'scheduleName': scheduleName,
    },
  ).catchError(() => throw ScheduleLoadError('Failed to add schedule'));
  return response.body;
}

Future<void> deleteSchedule({
  @required String userId,
  @required String scheduleId,
}) async {
  await http.post(deleteScheduleUrl, body: {
    'userId': userId,
    'scheduleId': scheduleId,
  }).catchError(() => throw ScheduleLoadError('Failed to delete schedule'));
}

Future<void> updateSchedule({
  @required String userId,
  @required String scheduleId,
  @required Map<String, Color> offerings,
}) async {
  // colors to strings
  Map<String, String> stringOfferings;
  for (final entry in offerings.entries) {
    stringOfferings[entry.key] = entry.value.toString();
  }
  await http.post(addScheduleUrl, body: {
    'userId': userId,
    'scheduleId': scheduleId,
    'offerings': stringOfferings,
  }).catchError(() => throw ScheduleLoadError('Failed to update schedule'));
}
