import 'dart:convert';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';

// Deploy instructions
// pub run build_runner build --output=build
// firebase deploy --only functions
// pub run build_runner build --output=build && firebase deploy --only functions

void main() {
  functions['allSchedules'] = functions.https.onRequest(allSchedules);
  functions['addSchedule'] = functions.https.onRequest(addSchedule);
  functions['updateSchedule'] = functions.https.onRequest(updateSchedule);
  functions['deleteSchedule'] = functions.https.onRequest(deleteSchedule);
}

final Firestore firestore = FirebaseAdmin.instance.initializeApp().firestore();

/// Return all schedules encoded as JSON
Future<void> allSchedules(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  if (userId == null) {
    print('User can not be null');
    throw HttpsError('FormattingError', 'User can not be null. Data recieved:',
        request.body);
  }
  final querySnapshot =
      await firestore.collection('users/$userId/schedules').get();
  if (querySnapshot == null) {
    print('User does not exist with that ID');
    throw HttpsError(
        'ServerError', 'User does not exist with the ID: $userId', null);
  }
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
    ..setNestedData('offerings', DocumentData())
    ..setString('name', scheduleName);
  final docRef =
      await firestore.collection('users/$userId/schedules').add(data);
  request.response.writeln(docRef.documentID);
  request.response.close();
}

/// Update the name and offerings of a schedule
Future<void> updateSchedule(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final String scheduleId = request.body['scheduleId'];
  final String scheduleName = request.body['scheduleName'];
  final Map<String, dynamic> colors = json.decode(request.body['colors']);
  final DocumentData offerings = DocumentData();
  colors.forEach((id, color) => offerings.setString(id, color));
  final data = DocumentData()
    ..setNestedData('offerings', offerings)
    ..setString('name', scheduleName);
  firestore.document('users/$userId/schedules/$scheduleId').setData(data);
  request.response.close();
}

/// Delete a schedule
Future<void> deleteSchedule(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final String scheduleId = request.body['scheduleId'];
  firestore.document('users/$userId/schedules/$scheduleId').delete();
  request.response.close();
}
