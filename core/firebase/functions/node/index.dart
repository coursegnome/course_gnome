import 'package:firebase_functions_interop/firebase_functions_interop.dart';

void main() {
  functions['allCourses'] = functions.https.onRequest(allCourses);
  functions['updateSchedule'] = functions.https.onRequest(updateSchedule);
  functions['deleteSchedule'] = functions.https.onRequest(deleteSchedule);
}
//
//Future<void> helloWorld(ExpressHttpRequest request) async {
//  request.response.writeln('Hello world');
//  request.response.close();
//  final App app = FirebaseAdmin.instance.initializeApp();
//  final docData = DocumentData()
//    ..setBool('here', true)
//    ..setString('2', 'x');
//  await app.firestore().document('').setData(docData);
//  app.auth().createUser(properties);
//}

Future<void> allCourses(ExpressHttpRequest request) async {}

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

  FirebaseAdmin.instance
      .initializeApp()
      .firestore()
      .document('$userId/schedules/$scheduleId')
      .setData(data);
}

Future<void> deleteSchedule(ExpressHttpRequest request) async {
  final String userId = request.body['userId'];
  final String scheduleId = request.body['scheduleId'];

  FirebaseAdmin.instance
      .initializeApp()
      .firestore()
      .document('$userId/schedules/$scheduleId')
      .delete();
}
