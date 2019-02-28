import 'dart:collection';

import 'package:core/core.dart';
import 'package:algolia/algolia.dart';

import 'config.dart' as algolia_config;

class SearchRepository {
  final client = SearchClient();
  final HashMap<Query, SearchResult> cache = HashMap<Query, SearchResult>();

  Future<SearchResult> results(Query query) async {
    if (cache.containsKey(query.stringCode)) {
      return cache[query.stringCode];
    } else {
      return client.search(query);
    }
  }
}

class SearchClient {
  static const index = 'gwu';
  static const Algolia algolia =
      Algolia.init(applicationId: '4AISU681XR', apiKey: algolia_config.apiKey);

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
