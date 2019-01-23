import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:course_gnome/model/Course.dart';
import 'package:course_gnome/model/UtilityClasses.dart';
import 'DummyData.dart';

class SearchObject {
  int offset = 0;
  String name;
  String departmentAcronym;

  SearchObject({this.name, this.departmentAcronym});
}

class SearchResults {
  int total = 0;
  List<Course> results = [];

  SearchResults({this.total, this.results});

  clear() {
    total = 0;
    results.clear();
  }
}

class Networking {
  static TimeOfDay _stringToTimeOfDay(String time) {
    final hms = time.split(":");
    return TimeOfDay(hour: int.parse(hms[0]), minute: int.parse(hms[1]));
  }

  static List<bool> _classTimeToDays(classTime) {
    var list = List.generate(7, (i) => false);
    if (classTime["sunday"]) list[0] = true;
    if (classTime["monday"]) list[1] = true;
    if (classTime["tuesday"]) list[2] = true;
    if (classTime["wednesday"]) list[3] = true;
    if (classTime["thursday"]) list[4] = true;
    if (classTime["friday"]) list[5] = true;
    if (classTime["saturday"]) list[6] = true;
    return list;
  }

  static ClassTime _parseClassTime(classTime) {
    return ClassTime(
        startTime: _stringToTimeOfDay(classTime["startTime"]),
        endTime: _stringToTimeOfDay(classTime["endTime"]),
        location: classTime["location"],
        days: _classTimeToDays(classTime));
  }

  static Offering _parseOffering(offering) {
    return Offering(
        status: offering["status"].toString().toUpperCase(),
        sectionNumber: offering["sectionNumber"].toString(),
        crn: offering["crn"].toString(),
        instructors: offering["instructors"],
        linkedOfferings: offering["linkedOfferings"] != null
            ? List.generate(offering["linkedOfferings"].length, (k) {
                return _parseOffering(offering["linkedOfferings"][k]);
              })
            : null,
        classTimes: List.generate(offering["classTimes"].length, (k) {
          return _parseClassTime(offering["classTimes"][k]);
        }));
  }

  static Course _parseCourse(course) {
    return Course(
      name: course["name"],
      credit: course["credit"].toString(),
      description: course["description"],
      departmentNumber: course["departmentNumberString"],
      departmentAcronym: course["departmentAcronym"],
      bulletinLink: course["bulletinLink"],
      offerings: List.generate(
        course["offerings"].length,
        (j) {
          return _parseOffering(course["offerings"][j]);
        },
      ),
    );
  }

  static _parseCourses(courses) {
    return List.generate(
      courses.length,
      (i) {
        return _parseCourse(courses[i]);
      },
    );
  }

  static const getCoursesURL =
      'https://us-central1-course-gnome.cloudfunctions.net/getCourses';

  static Future<SearchResults> getCourses(
      SearchObject searchObject) async {
    try {
      final Map<String, dynamic> params = {
        'name': searchObject.name,
        'limit': 10,
        'offset': searchObject.offset,
      };
//      final resp = http.post(getCoursesURL, body: params);
//      final coursesJson = resp.body['courses'];
//      final courses = jsonDecode(coursesJson);
//      return SearchResults(results: _parseCourses(courses), total: resp.body['count']);
      return SearchResults(results: _parseCourses(DummyData.dummyJson), total: 11);
    } catch (e) {
      print('caught generic exception');
      print(e);
      return null;
    }
  }

}
