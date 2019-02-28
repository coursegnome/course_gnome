import 'dart:convert';
import 'package:core/core.dart';
import 'package:algolia/algolia.dart';
import 'package:http/http.dart' as http;

class SchedulesRepository {
  final client = SearchClient();
  final cache = <String, SearchResult>{};

  static const addScheduleUrl =
      'https://us-central1-course-gnome.cloudfunctions.net/addSchedule';
  static const deleteScheduleUrl =
      'https://us-central1-course-gnome.cloudfunctions.net/deleteSchedule';
  static const allSchedulesUrl =
      'https://us-central1-course-gnome.cloudfunctions.net/allSchedules';
  static const updateScheduleUrl =
      'https://us-central1-course-gnome.cloudfunctions.net/updateSchedule';

  Future<Schedules> allSchedules(String userId) async {
    final Schedules schedules = Schedules();
    final response = await http.post(allSchedulesUrl, body: {'userId': userId});
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json.
  }
}

class SearchClient {
  static const index = 'gwu';
  static const Algolia algolia =
      Algolia.init(applicationId: '4AISU681XR', apiKey: AlgoliaConfig.apiKey);

  Future<SearchResult> search(Query query) async {
    AlgoliaQuery _algQuery =
        algolia.instance.index('contacts').search(query.text);
    _algQuery.setFilters(formQueryString(query));
    AlgoliaQuerySnapshot _snap = await _algQuery.getObjects();
    return SearchResult.fromSnapshot(_snap);
  }

  String formQueryString(Query query) {
    return 'price < 10 AND (category:Book OR NOT category:Ebook)';
  }
}
