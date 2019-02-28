import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:color/color.dart';

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
  final response = await http.post(allSchedulesUrl, body: {
    'userId': userId
  }).catchError(() => throw ScheduleLoadError('Failed to load schedules'));
}

Future<void> addSchedule({
  @required String userId,
  @required String scheduleName,
}) async {
  await http.post(addScheduleUrl, body: {
    'userId': userId,
    'scheduleName': scheduleName,
  }).catchError(() => throw ScheduleTransactionError('Failed to add schedule'));
}

Future<void> deleteSchedule({
  @required String userId,
  @required String scheduleId,
}) async {
  await http.post(deleteScheduleUrl, body: {
    'userId': userId,
    'scheduleId': scheduleId,
  }).catchError(
      () => throw ScheduleTransactionError('Failed to delete schedule'));
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
  }).catchError(
      () => throw ScheduleTransactionError('Failed to update schedule'));
}
