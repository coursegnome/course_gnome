import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:course_gnome/model/Course.dart';
import 'package:course_gnome/model/UtilityClasses.dart';

class SearchObject {
  String name;
  String departmentAcronym;

  SearchObject({this.name, this.departmentAcronym});
}

class CourseResults {
  int total;
  List<Course> results;

  CourseResults({this.total, this.results});

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

  static const getCoursesURL = 'https://us-central1-course-gnome.cloudfunctions.net/getCourses';

  static Future<CourseResults> getCourses(
      SearchObject searchObject, int offset) async {
    try {
      final Map<String, dynamic> params = {
        'name': searchObject.name,
        'limit': 10,
        'offset': offset,
      };
      final resp = http.post(getCoursesURL, body: params);
//      final coursesJson = resp.body['courses'];
//      final courses = jsonDecode(coursesJson);
//      return CourseResults(results: _parseCourses(courses), total: resp.body['count']);
      return CourseResults(results: _parseCourses(dummyJson), total: 9);
    } catch (e) {
      print('caught generic exception');
      print(e);
      return null;
    }
  }

  static const List<Map<String, dynamic>> dummyJson = [
    {
      "id": "0-0-AFST-1001",
      "school": 0,
      "season": 0,
      "departmentAcronym": "AFST",
      "departmentNumberString": "1001",
      "departmentNumber": 1001,
      "name": "Introduction to Africana Studies",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=AFST+1001",
      "live": false,
      "offerings": [
        {
          "instructors": "Bell and Evans, K",
          "linkedOfferings": [
            {
              "instructors": "Bell and Evans, K",
              "id": "0-0-AFST-1001-10",
              "sectionNumber": "10",
              "earliestStartTime": "12:45:00",
              "latestEndTime": "14:00:00",
              "status": "waitlist",
              "someMonday": null,
              "someTuesday": true,
              "someWednesday": null,
              "someThursday": true,
              "someFriday": null,
              "someSaturday": null,
              "someSunday": null,
              "crn": 48028,
              "courseId": "0-0-AFST-1001",
              "classTimes": [
                {
                  "id": 1,
                  "startTime": "12:45:00",
                  "endTime": "14:00:00",
                  "location": "ROME 352",
                  "monday": false,
                  "tuesday": true,
                  "wednesday": false,
                  "thursday": true,
                  "friday": false,
                  "saturday": false,
                  "sunday": false,
                  "offeringId": "0-0-AFST-1001-10"
                }
              ]
            },
            {
              "instructors": "Bell and Evans, K",
              "id": "0-0-AFST-1001-10",
              "sectionNumber": "10",
              "earliestStartTime": "12:45:00",
              "latestEndTime": "14:00:00",
              "status": "waitlist",
              "someMonday": null,
              "someTuesday": true,
              "someWednesday": null,
              "someThursday": true,
              "someFriday": null,
              "someSaturday": null,
              "someSunday": null,
              "crn": 48028,
              "courseId": "0-0-AFST-1001",
              "classTimes": [
                {
                  "id": 1,
                  "startTime": "12:45:00",
                  "endTime": "14:00:00",
                  "location": "ROME 352",
                  "monday": false,
                  "tuesday": true,
                  "wednesday": false,
                  "thursday": true,
                  "friday": false,
                  "saturday": false,
                  "sunday": false,
                  "offeringId": "0-0-AFST-1001-10"
                }
              ]
            }
          ],
          "id": "0-0-AFST-1001-10",
          "sectionNumber": "10",
          "earliestStartTime": "12:45:00",
          "latestEndTime": "14:00:00",
          "status": "waitlist",
          "someMonday": null,
          "someTuesday": true,
          "someWednesday": null,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 48028,
          "courseId": "0-0-AFST-1001",
          "classTimes": [
            {
              "id": 1,
              "startTime": "12:45:00",
              "endTime": "14:00:00",
              "location": "ROME 352",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-AFST-1001-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-AH-1031",
      "school": 0,
      "season": 0,
      "departmentAcronym": "AH",
      "departmentNumberString": "1031",
      "departmentNumber": 1031,
      "name": "Survey of Art and Architecture I",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=AH+1031",
      "live": false,
      "offerings": [
        {
          "id": "0-0-AH-1031-10",
          "sectionNumber": "10",
          "earliestStartTime": "12:45:00",
          "latestEndTime": "14:00:00",
          "status": "open",
          "someMonday": true,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 47978,
          "courseId": "0-0-AH-1031",
          "classTimes": [
            {
              "id": 25,
              "startTime": "12:45:00",
              "endTime": "14:00:00",
              "location": "SMTH 114",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-AH-1031-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-AH-1032",
      "school": 0,
      "season": 0,
      "departmentAcronym": "AH",
      "departmentNumberString": "1032",
      "departmentNumber": 1032,
      "name": "Survey of Art and Architecture II",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=AH+1032",
      "live": false,
      "offerings": [
        {
          "id": "0-0-AH-1032-10",
          "sectionNumber": "10",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:25:00",
          "status": "closed",
          "someMonday": null,
          "someTuesday": true,
          "someWednesday": null,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 42098,
          "courseId": "0-0-AH-1032",
          "classTimes": [
            {
              "id": 26,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "SMTH 114",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-AH-1032-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-AMST-1050",
      "school": 0,
      "season": 0,
      "departmentAcronym": "AMST",
      "departmentNumberString": "1050",
      "departmentNumber": 1050,
      "name": "Bodies of Work",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=AMST+1050",
      "live": false,
      "offerings": [
        {
          "id": "0-0-AMST-1050-10",
          "sectionNumber": "10",
          "earliestStartTime": "14:20:00",
          "latestEndTime": "15:35:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 48575,
          "courseId": "0-0-AMST-1050",
          "classTimes": [
            {
              "id": 2,
              "startTime": "14:20:00",
              "endTime": "15:35:00",
              "location": "DHSE B117",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-AMST-1050-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ANTH-1001",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ANTH",
      "departmentNumberString": "1001",
      "departmentNumber": 1001,
      "name": "Biological Anthropology",
      "credit": 4,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ANTH+1001",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ANTH-1001-10",
          "sectionNumber": "10",
          "earliestStartTime": "12:45:00",
          "latestEndTime": "14:00:00",
          "status": "closed",
          "someMonday": true,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 41164,
          "courseId": "0-0-ANTH-1001",
          "classTimes": [
            {
              "id": 3,
              "startTime": "12:45:00",
              "endTime": "14:00:00",
              "location": "FNGR 103",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ANTH-1001-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ANTH-1002",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ANTH",
      "departmentNumberString": "1002",
      "departmentNumber": 1002,
      "name": "Sociocultural Anthropology",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ANTH+1002",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ANTH-1002-10",
          "sectionNumber": "10",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:25:00",
          "status": "open",
          "someMonday": null,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": true,
          "someSaturday": null,
          "someSunday": null,
          "crn": 40024,
          "courseId": "0-0-ANTH-1002",
          "classTimes": [
            {
              "id": 4,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "1957 E 213",
              "monday": false,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": true,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ANTH-1002-10"
            }
          ]
        },
        {
          "id": "0-0-ANTH-1002-11",
          "sectionNumber": "11",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:25:00",
          "status": "waitlist",
          "someMonday": null,
          "someTuesday": true,
          "someWednesday": null,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 47983,
          "courseId": "0-0-ANTH-1002",
          "classTimes": [
            {
              "id": 5,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "FNGR 209",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ANTH-1002-11"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ANTH-1003",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ANTH",
      "departmentNumberString": "1003",
      "departmentNumber": 1003,
      "name": "Archaeology",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ANTH+1003",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ANTH-1003-10",
          "sectionNumber": "10",
          "earliestStartTime": "09:35:00",
          "latestEndTime": "10:50:00",
          "status": "open",
          "someMonday": null,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": true,
          "someSaturday": null,
          "someSunday": null,
          "crn": 40027,
          "courseId": "0-0-ANTH-1003",
          "classTimes": [
            {
              "id": 6,
              "startTime": "09:35:00",
              "endTime": "10:50:00",
              "location": "FNGR 222",
              "monday": false,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": true,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ANTH-1003-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ANTH-1004",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ANTH",
      "departmentNumberString": "1004",
      "departmentNumber": 1004,
      "name": "Language in Culture and Society",
      "credit": 3,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ANTH+1004",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ANTH-1004-10",
          "sectionNumber": "10",
          "earliestStartTime": "09:35:00",
          "latestEndTime": "10:25:00",
          "status": "closed",
          "someMonday": null,
          "someTuesday": true,
          "someWednesday": null,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 40028,
          "courseId": "0-0-ANTH-1004",
          "classTimes": [
            {
              "id": 7,
              "startTime": "09:35:00",
              "endTime": "10:25:00",
              "location": "1957 E B12",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ANTH-1004-10"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ARAB-1002",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ARAB",
      "departmentNumberString": "1002",
      "departmentNumber": 1002,
      "name": "Beginning Arabic II",
      "credit": 4,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ARAB+1002",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ARAB-1002-10",
          "sectionNumber": "10",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:00:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 43119,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 8,
              "startTime": "11:10:00",
              "endTime": "12:00:00",
              "location": "TOMP 205",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-10"
            },
            {
              "id": 9,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "LISH 335",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-10"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-11",
          "sectionNumber": "11",
          "earliestStartTime": "14:20:00",
          "latestEndTime": "15:10:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": null,
          "someThursday": true,
          "someFriday": true,
          "someSaturday": null,
          "someSunday": null,
          "crn": 42805,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 10,
              "startTime": "14:20:00",
              "endTime": "15:10:00",
              "location": "DUQUES 259",
              "monday": true,
              "tuesday": false,
              "wednesday": false,
              "thursday": false,
              "friday": true,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-11"
            },
            {
              "id": 11,
              "startTime": "14:20:00",
              "endTime": "15:35:00",
              "location": "TOMP 310",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-11"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-12",
          "sectionNumber": "12",
          "earliestStartTime": "17:10:00",
          "latestEndTime": "18:00:00",
          "status": "open",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 41423,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 12,
              "startTime": "17:10:00",
              "endTime": "18:00:00",
              "location": "1957 E 211",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-12"
            },
            {
              "id": 13,
              "startTime": "16:45:00",
              "endTime": "18:00:00",
              "location": "1957 E 311",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-12"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-13",
          "sectionNumber": "13",
          "earliestStartTime": "14:20:00",
          "latestEndTime": "15:10:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 42806,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 14,
              "startTime": "14:20:00",
              "endTime": "15:10:00",
              "location": "TOMP 309",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-13"
            },
            {
              "id": 15,
              "startTime": "14:20:00",
              "endTime": "15:35:00",
              "location": "MPA 208",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-13"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-14",
          "sectionNumber": "14",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:00:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 41528,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 16,
              "startTime": "11:10:00",
              "endTime": "12:00:00",
              "location": "TOMP 310",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-14"
            },
            {
              "id": 17,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "TOMP 204",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-14"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-15",
          "sectionNumber": "15",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:00:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 41583,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 18,
              "startTime": "11:10:00",
              "endTime": "12:00:00",
              "location": "PHIL 416",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-15"
            },
            {
              "id": 19,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "MON 252",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-15"
            },
            {
              "id": 20,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "MON B36",
              "monday": false,
              "tuesday": false,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-15"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-16",
          "sectionNumber": "16",
          "earliestStartTime": "09:35:00",
          "latestEndTime": "10:25:00",
          "status": "open",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 41641,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 21,
              "startTime": "09:35:00",
              "endTime": "10:25:00",
              "location": "PHIL 510",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-16"
            },
            {
              "id": 22,
              "startTime": "09:35:00",
              "endTime": "10:50:00",
              "location": "MON B36",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-16"
            }
          ]
        },
        {
          "id": "0-0-ARAB-1002-17",
          "sectionNumber": "17",
          "earliestStartTime": "12:45:00",
          "latestEndTime": "13:35:00",
          "status": "open",
          "someMonday": true,
          "someTuesday": true,
          "someWednesday": true,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 45935,
          "courseId": "0-0-ARAB-1002",
          "classTimes": [
            {
              "id": 23,
              "startTime": "12:45:00",
              "endTime": "13:35:00",
              "location": "SEH 7040",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-17"
            },
            {
              "id": 24,
              "startTime": "12:45:00",
              "endTime": "14:00:00",
              "location": "MPA 208",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ARAB-1002-17"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ASTR-1001",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ASTR",
      "departmentNumberString": "1001",
      "departmentNumber": 1001,
      "name": "Stars, Planets, and Life in the Universe",
      "credit": 4,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ASTR+1001",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ASTR-1001-10",
          "sectionNumber": "10",
          "earliestStartTime": "11:10:00",
          "latestEndTime": "12:25:00",
          "status": "open",
          "someMonday": true,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 41238,
          "courseId": "0-0-ASTR-1001",
          "classTimes": [
            {
              "id": 27,
              "startTime": "11:10:00",
              "endTime": "12:25:00",
              "location": "COR 101",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ASTR-1001-10"
            }
          ]
        },
        {
          "id": "0-0-ASTR-1001-11",
          "sectionNumber": "11",
          "earliestStartTime": "18:00:00",
          "latestEndTime": "20:00:00",
          "status": "waitlist",
          "someMonday": true,
          "someTuesday": null,
          "someWednesday": true,
          "someThursday": null,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 42306,
          "courseId": "0-0-ASTR-1001",
          "classTimes": [
            {
              "id": 28,
              "startTime": "18:00:00",
              "endTime": "20:00:00",
              "location": "COR 203",
              "monday": true,
              "tuesday": false,
              "wednesday": true,
              "thursday": false,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ASTR-1001-11"
            }
          ]
        }
      ]
    },
    {
      "id": "0-0-ASTR-1002",
      "school": 0,
      "season": 0,
      "departmentAcronym": "ASTR",
      "departmentNumberString": "1002",
      "departmentNumber": 1002,
      "name": "Origins of the Cosmos",
      "credit": 4,
      "description": null,
      "bulletinLink": "http://bulletin.gwu.edu/search/?P=ASTR+1002",
      "live": false,
      "offerings": [
        {
          "id": "0-0-ASTR-1002-10",
          "sectionNumber": "10",
          "earliestStartTime": "12:45:00",
          "latestEndTime": "14:00:00",
          "status": "open",
          "someMonday": null,
          "someTuesday": true,
          "someWednesday": null,
          "someThursday": true,
          "someFriday": null,
          "someSaturday": null,
          "someSunday": null,
          "crn": 42562,
          "courseId": "0-0-ASTR-1002",
          "classTimes": [
            {
              "id": 29,
              "startTime": "12:45:00",
              "endTime": "14:00:00",
              "location": "COR 103",
              "monday": false,
              "tuesday": true,
              "wednesday": false,
              "thursday": true,
              "friday": false,
              "saturday": false,
              "sunday": false,
              "offeringId": "0-0-ASTR-1002-10"
            }
          ]
        }
      ]
    }
  ];

  static const jsonString =
      '[{"id":"0-0-AFST-1001","school":0,"season":0,"departmentAcronym":"AFST","departmentNumberString":"1001","departmentNumber":1001,"name":"Introduction to Africana Studies","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=AFST+1001","live":false,"offerings":[{"id":"0-0-AFST-1001-10","linkedOfferings":[{"sectionNumber":1,"crn":12121,"classTimes":[{"id":1,"startTime":"12:45:00","endTime":"14:00:00","location":"ROME 352","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-AFST-1001-10"}]}]}],"instructors":"BellandEvans, M.","sectionNumber":"10","earliestStartTime":"12:45:00","latestEndTime":"14:00:00","status":"waitlist","someMonday":null,"someTuesday":true,"someWednesday":null,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":48028,"courseId":"0-0-AFST-1001","classTimes":[{"id":1,"startTime":"12:45:00","endTime":"14:00:00","location":"ROME 352","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-AFST-1001-10"}]},{"id":"0-0-AH-1031","school":0,"season":0,"departmentAcronym":"AH","departmentNumberString":"1031","departmentNumber":1031,"name":"Survey of Art and Architecture I","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=AH+1031","live":false,"offerings":[{"id":"0-0-AH-1031-10","sectionNumber":"10","earliestStartTime":"12:45:00","latestEndTime":"14:00:00","status":"open","someMonday":true,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":47978,"courseId":"0-0-AH-1031","classTimes":[{"id":25,"startTime":"12:45:00","endTime":"14:00:00","location":"SMTH 114","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-AH-1031-10"}]}]},{"id":"0-0-AH-1032","school":0,"season":0,"departmentAcronym":"AH","departmentNumberString":"1032","departmentNumber":1032,"name":"Survey of Art and Architecture II","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=AH+1032","live":false,"offerings":[{"id":"0-0-AH-1032-10","sectionNumber":"10","earliestStartTime":"11:10:00","latestEndTime":"12:25:00","status":"closed","someMonday":null,"someTuesday":true,"someWednesday":null,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":42098,"courseId":"0-0-AH-1032","classTimes":[{"id":26,"startTime":"11:10:00","endTime":"12:25:00","location":"SMTH 114","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-AH-1032-10"}]}]},{"id":"0-0-AMST-1050","school":0,"season":0,"departmentAcronym":"AMST","departmentNumberString":"1050","departmentNumber":1050,"name":"Bodies of Work","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=AMST+1050","live":false,"offerings":[{"id":"0-0-AMST-1050-10","sectionNumber":"10","earliestStartTime":"14:20:00","latestEndTime":"15:35:00","status":"waitlist","someMonday":true,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":48575,"courseId":"0-0-AMST-1050","classTimes":[{"id":2,"startTime":"14:20:00","endTime":"15:35:00","location":"DHSE B117","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-AMST-1050-10"}]}]},{"id":"0-0-ANTH-1001","school":0,"season":0,"departmentAcronym":"ANTH","departmentNumberString":"1001","departmentNumber":1001,"name":"Biological Anthropology","credit":4,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ANTH+1001","live":false,"offerings":[{"id":"0-0-ANTH-1001-10","sectionNumber":"10","earliestStartTime":"12:45:00","latestEndTime":"14:00:00","status":"closed","someMonday":true,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":41164,"courseId":"0-0-ANTH-1001","classTimes":[{"id":3,"startTime":"12:45:00","endTime":"14:00:00","location":"FNGR 103","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ANTH-1001-10"}]}]},{"id":"0-0-ANTH-1002","school":0,"season":0,"departmentAcronym":"ANTH","departmentNumberString":"1002","departmentNumber":1002,"name":"Sociocultural Anthropology","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ANTH+1002","live":false,"offerings":[{"id":"0-0-ANTH-1002-10","sectionNumber":"10","earliestStartTime":"11:10:00","latestEndTime":"12:25:00","status":"open","someMonday":null,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":true,"someSaturday":null,"someSunday":null,"crn":40024,"courseId":"0-0-ANTH-1002","classTimes":[{"id":4,"startTime":"11:10:00","endTime":"12:25:00","location":"1957 E 213","monday":false,"tuesday":false,"wednesday":true,"thursday":false,"friday":true,"saturday":false,"sunday":false,"offeringId":"0-0-ANTH-1002-10"}]},{"id":"0-0-ANTH-1002-11","sectionNumber":"11","earliestStartTime":"11:10:00","latestEndTime":"12:25:00","status":"waitlist","someMonday":null,"someTuesday":true,"someWednesday":null,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":47983,"courseId":"0-0-ANTH-1002","classTimes":[{"id":5,"startTime":"11:10:00","endTime":"12:25:00","location":"FNGR 209","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ANTH-1002-11"}]}]},{"id":"0-0-ANTH-1003","school":0,"season":0,"departmentAcronym":"ANTH","departmentNumberString":"1003","departmentNumber":1003,"name":"Archaeology","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ANTH+1003","live":false,"offerings":[{"id":"0-0-ANTH-1003-10","sectionNumber":"10","earliestStartTime":"09:35:00","latestEndTime":"10:50:00","status":"open","someMonday":null,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":true,"someSaturday":null,"someSunday":null,"crn":40027,"courseId":"0-0-ANTH-1003","classTimes":[{"id":6,"startTime":"09:35:00","endTime":"10:50:00","location":"FNGR 222","monday":false,"tuesday":false,"wednesday":true,"thursday":false,"friday":true,"saturday":false,"sunday":false,"offeringId":"0-0-ANTH-1003-10"}]}]},{"id":"0-0-ANTH-1004","school":0,"season":0,"departmentAcronym":"ANTH","departmentNumberString":"1004","departmentNumber":1004,"name":"Language in Culture and Society","credit":3,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ANTH+1004","live":false,"offerings":[{"id":"0-0-ANTH-1004-10","sectionNumber":"10","earliestStartTime":"09:35:00","latestEndTime":"10:25:00","status":"closed","someMonday":null,"someTuesday":true,"someWednesday":null,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":40028,"courseId":"0-0-ANTH-1004","classTimes":[{"id":7,"startTime":"09:35:00","endTime":"10:25:00","location":"1957 E B12","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ANTH-1004-10"}]}]},{"id":"0-0-ARAB-1002","school":0,"season":0,"departmentAcronym":"ARAB","departmentNumberString":"1002","departmentNumber":1002,"name":"Beginning Arabic II","credit":4,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ARAB+1002","live":false,"offerings":[{"id":"0-0-ARAB-1002-10","sectionNumber":"10","earliestStartTime":"11:10:00","latestEndTime":"12:00:00","status":"waitlist","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":43119,"courseId":"0-0-ARAB-1002","classTimes":[{"id":8,"startTime":"11:10:00","endTime":"12:00:00","location":"TOMP 205","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-10"},{"id":9,"startTime":"11:10:00","endTime":"12:25:00","location":"LISH 335","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-10"}]},{"id":"0-0-ARAB-1002-11","sectionNumber":"11","earliestStartTime":"14:20:00","latestEndTime":"15:10:00","status":"waitlist","someMonday":true,"someTuesday":true,"someWednesday":null,"someThursday":true,"someFriday":true,"someSaturday":null,"someSunday":null,"crn":42805,"courseId":"0-0-ARAB-1002","classTimes":[{"id":10,"startTime":"14:20:00","endTime":"15:10:00","location":"DUQUES 259","monday":true,"tuesday":false,"wednesday":false,"thursday":false,"friday":true,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-11"},{"id":11,"startTime":"14:20:00","endTime":"15:35:00","location":"TOMP 310","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-11"}]},{"id":"0-0-ARAB-1002-12","sectionNumber":"12","earliestStartTime":"17:10:00","latestEndTime":"18:00:00","status":"open","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":41423,"courseId":"0-0-ARAB-1002","classTimes":[{"id":12,"startTime":"17:10:00","endTime":"18:00:00","location":"1957 E 211","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-12"},{"id":13,"startTime":"16:45:00","endTime":"18:00:00","location":"1957 E 311","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-12"}]},{"id":"0-0-ARAB-1002-13","sectionNumber":"13","earliestStartTime":"14:20:00","latestEndTime":"15:10:00","status":"waitlist","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":42806,"courseId":"0-0-ARAB-1002","classTimes":[{"id":14,"startTime":"14:20:00","endTime":"15:10:00","location":"TOMP 309","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-13"},{"id":15,"startTime":"14:20:00","endTime":"15:35:00","location":"MPA 208","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-13"}]},{"id":"0-0-ARAB-1002-14","sectionNumber":"14","earliestStartTime":"11:10:00","latestEndTime":"12:00:00","status":"waitlist","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":41528,"courseId":"0-0-ARAB-1002","classTimes":[{"id":16,"startTime":"11:10:00","endTime":"12:00:00","location":"TOMP 310","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-14"},{"id":17,"startTime":"11:10:00","endTime":"12:25:00","location":"TOMP 204","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-14"}]},{"id":"0-0-ARAB-1002-15","sectionNumber":"15","earliestStartTime":"11:10:00","latestEndTime":"12:00:00","status":"waitlist","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":41583,"courseId":"0-0-ARAB-1002","classTimes":[{"id":18,"startTime":"11:10:00","endTime":"12:00:00","location":"PHIL 416","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-15"},{"id":19,"startTime":"11:10:00","endTime":"12:25:00","location":"MON 252","monday":false,"tuesday":true,"wednesday":false,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-15"},{"id":20,"startTime":"11:10:00","endTime":"12:25:00","location":"MON B36","monday":false,"tuesday":false,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-15"}]},{"id":"0-0-ARAB-1002-16","sectionNumber":"16","earliestStartTime":"09:35:00","latestEndTime":"10:25:00","status":"open","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":41641,"courseId":"0-0-ARAB-1002","classTimes":[{"id":21,"startTime":"09:35:00","endTime":"10:25:00","location":"PHIL 510","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-16"},{"id":22,"startTime":"09:35:00","endTime":"10:50:00","location":"MON B36","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-16"}]},{"id":"0-0-ARAB-1002-17","sectionNumber":"17","earliestStartTime":"12:45:00","latestEndTime":"13:35:00","status":"open","someMonday":true,"someTuesday":true,"someWednesday":true,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":45935,"courseId":"0-0-ARAB-1002","classTimes":[{"id":23,"startTime":"12:45:00","endTime":"13:35:00","location":"SEH 7040","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-17"},{"id":24,"startTime":"12:45:00","endTime":"14:00:00","location":"MPA 208","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ARAB-1002-17"}]}]},{"id":"0-0-ASTR-1001","school":0,"season":0,"departmentAcronym":"ASTR","departmentNumberString":"1001","departmentNumber":1001,"name":"Stars, Planets, and Life in the Universe","credit":4,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ASTR+1001","live":false,"offerings":[{"id":"0-0-ASTR-1001-10","sectionNumber":"10","earliestStartTime":"11:10:00","latestEndTime":"12:25:00","status":"open","someMonday":true,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":41238,"courseId":"0-0-ASTR-1001","classTimes":[{"id":27,"startTime":"11:10:00","endTime":"12:25:00","location":"COR 101","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ASTR-1001-10"}]},{"id":"0-0-ASTR-1001-11","sectionNumber":"11","earliestStartTime":"18:00:00","latestEndTime":"20:00:00","status":"waitlist","someMonday":true,"someTuesday":null,"someWednesday":true,"someThursday":null,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":42306,"courseId":"0-0-ASTR-1001","classTimes":[{"id":28,"startTime":"18:00:00","endTime":"20:00:00","location":"COR 203","monday":true,"tuesday":false,"wednesday":true,"thursday":false,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ASTR-1001-11"}]}]},{"id":"0-0-ASTR-1002","school":0,"season":0,"departmentAcronym":"ASTR","departmentNumberString":"1002","departmentNumber":1002,"name":"Origins of the Cosmos","credit":4,"description":null,"bulletinLink":"http://bulletin.gwu.edu/search/?P=ASTR+1002","live":false,"offerings":[{"id":"0-0-ASTR-1002-10","sectionNumber":"10","earliestStartTime":"12:45:00","latestEndTime":"14:00:00","status":"open","someMonday":null,"someTuesday":true,"someWednesday":null,"someThursday":true,"someFriday":null,"someSaturday":null,"someSunday":null,"crn":42562,"courseId":"0-0-ASTR-1002","classTimes":[{"id":29,"startTime":"12:45:00","endTime":"14:00:00","location":"COR 103","monday":false,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":false,"offeringId":"0-0-ASTR-1002-10"}]}]}]';
}
