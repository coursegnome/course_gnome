import 'dart:collection';

import 'package:algolia/algolia.dart';

import 'package:course_gnome/state/search/search.dart';
import 'package:course_gnome/state/shared/models/course.dart';
import 'package:course_gnome/state/shared/config/config.dart';

/*
   1. On search, check cache to see if query has been searched. If so, return.
   2. Else, search  

   1. On fetchMore, load result from cache.
   2. return if 
*/

class SearchRepository {
  Query currentQuery;

  final SearchClient _client = SearchClient();
  final HashMap<Query, CachedSearchResult> _cache =
      HashMap<Query, CachedSearchResult>();

  Future<SearchResult> search(Query query) async {
    currentQuery = query;
    if (!_cache.containsKey(query)) {
      _cache[query] = CachedSearchResult.fromSnapshot(
        snap: await _client.search(query, 0),
      );
    }
    return _cache[query].result;
  }

  Future<SearchResult> loadMore() async {
    CachedSearchResult currentResult = _cache[currentQuery];
    currentResult = CachedSearchResult.fromSnapshot(
      snap: await _client.search(currentQuery, currentResult.page + 1),
      currentResult: currentResult,
    );
    return _cache[currentQuery].result;
  }
}

class SearchClient {
  Future<AlgoliaQuerySnapshot> search(Query query, int page) async {
    String index = 'offerings';
    AlgoliaQuery _query = algolia.index(index);
    _query = query.text != null ? _query.search(query.text) : _query;
    _query = _query.setFilters(_buildFilterString(query));
    _query = _query.setPage(page);
    return await _query.getObjects();
  }

  String _buildFilterString(Query query) {
    String _string =
        'school: ${query.school.id} AND season: ${query.season.id}';

    if (query.departments.isNotEmpty) {
      _string += ' AND (deptAcr:${query.departments.first}';
      for (final department
          in query.departments.sublist(1, query.departments.length)) {
        _string += ' OR deptAcr:$department';
      }
      _string += ')';
    }

    if (query.statuses.isNotEmpty) {
      _string += ' AND (status:${_stringForStatus(query.statuses.first)}';
      for (final status in query.statuses.sublist(1, query.statuses.length)) {
        _string += ' OR deptAcr:${_stringForStatus(status)}';
      }
      _string += ')';
    }

    if (query.minDepartmentNumber != null) {
      _string += ' AND deptNumInt >= ${query.minDepartmentNumber}';
    }

    if (query.maxDepartmentNumber != null) {
      _string += ' AND deptNumInt <= ${query.maxDepartmentNumber}';
    }

    if (query.earliestStartTime != null) {
      _string += ' AND range.start >= ${query.earliestStartTime.timestamp}';
    }

    if (query.latestEndTime != null) {
      _string += ' AND range.end <= ${query.latestEndTime.timestamp}';
    }

    for (var i = 0; i < Query.dayStrings.length; ++i) {
      if (!query.days[i]) {
        _string += ' AND NOT range.${Query.dayStrings[i]}';
      }
    }
    return _string;
  }

  String _stringForStatus(Status status) => _enumValue(status.toString());

  String _enumValue(String enumString) =>
      enumString.substring(enumString.indexOf('.') + 1);
}
