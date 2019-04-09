import 'dart:collection';

import 'package:core/core.dart';
import 'package:algolia/algolia.dart';

import 'config.dart';

/*
   1. On search, check cache to see if query has been searched. If so, return.
   2. Else, search  

   1. On fetchMore, load result from cache.
   2. return if 
*/

class SearchRepository {
  static const hitCount = 30;
  final SearchClient _client = SearchClient();
  final HashMap<Query, SearchResult> _cache = HashMap<Query, SearchResult>();

  Future<SearchResult> search(Query query) async {
    if (!_cache.containsKey(query)) {
      _cache[query] = SearchResult.fromSnapshot(await _client.search(query, 0));
    }
    return _cache[query];
  }

  Future<SearchResult> fetchMore(Query query) async {
    final SearchResult result = _cache[query];
    if (result.isMaxedOut) {
      return result;
    }
    _cache[query] = SearchResult.fromSnapshot(
        await _client.search(query, result.page + 1), result);
    return _cache[query];
  }
}

class SearchClient {
  Future<AlgoliaQuerySnapshot> search(Query query, int page) async {
    AlgoliaQuery _query = algolia.index(index);
    _query = query.text != null ? _query.search(query.text) : _query;
    _query = _query.setFilters(_buildFilterString(query));
    _query = _query.setPage(page);
    return await _query.getObjects();
  }

  String _buildFilterString(Query query) {
    String _string =
        'school: ${query.school.id} AND season: ${query.season.id}';

    if (query.departments != null) {
      _string += ' AND (deptAcr:${query.departments.first}';
      for (final department
          in query.departments.sublist(1, query.departments.length)) {
        _string += ' OR deptAcr:$department';
      }
      _string += ')';
    }

    if (query.statuses != null) {
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
      enumString.substring(enumString.toString().indexOf('.') + 1);
}
