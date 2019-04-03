import 'dart:collection';

import 'package:core/core.dart';
import 'package:algolia/algolia.dart';

import 'config.dart';

class SearchRepository {
  final client = SearchClient();
  final HashMap<Query, SearchResult> cache = HashMap<Query, SearchResult>();

  Future<SearchResult> results(Query query) async {
    if (cache.containsKey(query.toString())) {
      return cache[query.toString()];
    } else {
      return client.search(query);
    }
  }
}

class SearchClient {
  static const index = 'gwu';

  Future<SearchResult> search(Query query) async {
    final AlgoliaQuery _algQuery = algolia.instance
        .index('contacts')
        .search(query.text)
          ..setFilters(query.toString());
    final AlgoliaQuerySnapshot _snap = await _algQuery.getObjects();
    return SearchResult.fromSnapshot(_snap);
  }
}
