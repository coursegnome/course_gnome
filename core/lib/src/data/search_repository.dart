import 'package:core/core.dart';
import 'config.dart';
import 'package:algolia/algolia.dart';

class SearchRepository {
  final client = SearchClient();
  final cache = <String, SearchResult>{};

  Future<SearchResult> getResults(Query query) async {
    if (cache.containsKey(query.stringCode)) {
      return cache[query.stringCode];
    } else
      return client.search(query);
  }
}

class SearchClient {
  static const index = 'gwu';
  final Algolia algolia =
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
