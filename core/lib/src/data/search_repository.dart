import 'package:core/core.dart';

class SearchRepository {
  final client = SearchClient();
  final cache = <String, SearchResults>{};

  Future<SearchResults> getResults(Query query) async {
    if (cache.containsKey(query.stringCode)) {
      return cache[query.stringCode];
    } else
      return client.search(query);
  }
}
