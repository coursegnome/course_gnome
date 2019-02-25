import 'dart:convert';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';

// Deploy instructions
// pub run build_runner build --output=build
// firebase deploy --only functions

void main() {
  functions['allSchedules'] = functions.https.onRequest(allSchedules);
  functions['addSchedule'] = functions.https.onRequest(addSchedule);
  functions['updateSchedule'] = functions.https.onRequest(updateSchedule);
  functions['deleteSchedule'] = functions.https.onRequest(deleteSchedule);
}

App initApp() {
  const serviceAccountKeyFilename = 'core/firebase/functions/service.json';
  final admin = FirebaseAdmin.instance;
  return admin.initializeApp(AppOptions(
    credential: admin.certFromPath(serviceAccountKeyFilename),
    databaseURL: 'https://course-gnome.firebaseio.com',
  ));
}

Future<void> allSchedules(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final querySnapshot = await FirebaseAdmin.instance
      .initializeApp()
      .firestore()
      .collection('$userId/schedules')
      .get();
  final List<Map<String, dynamic>> schedules = [];
  for (final doc in querySnapshot.documents) {
    schedules.add({doc.documentID: doc.data.toMap()});
  }
  request.response.writeln(jsonEncode(schedules));
  request.response.close();
}

/// Write a new schedule to the DB and return its ID for reference.
Future<void> addSchedule(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final String scheduleName = request.body['scheduleName'];
  final data = DocumentData()
    ..setNestedData('offerings', null)
    ..setString('scheduleName', scheduleName);
  final docRef =
      await initApp().firestore().collection('$userId/schedules').add(data);
  request.response.writeln(docRef.documentID);
  request.response.close();
}

/// Update the name and offerings of a schedule
Future<void> updateSchedule(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final String scheduleId = request.body['scheduleId'];
  final String scheduleName = request.body['scheduleName'];
  final Map<String, String> colors = request.body['colors'];
  final DocumentData offerings = DocumentData();
  colors.forEach((id, color) => offerings..setString(id, color));
  final data = DocumentData()
    ..setNestedData('offerings', offerings)
    ..setString('scheduleName', scheduleName);
  initApp().firestore().document('$userId/schedules/$scheduleId').setData(data);
  request.response.close();
}

/// Delete a schedule
Future<void> deleteSchedule(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final String scheduleId = request.body['scheduleId'];
  initApp().firestore().document('$userId/schedules/$scheduleId').delete();
  request.response.close();
}
