import 'package:meta/meta.dart';
import 'package:core/core.dart';
import 'package:algolia/algolia.dart';

class SearchResult {
  SearchResult({
    @required this.courses,
    @required this.totalHits,
    @required this.totalPages,
    @required this.page,
  })  : assert(courses != null),
        assert(totalHits != null),
        assert(totalPages != null),
        assert(page != null);

  final List<Course> courses;
  final int totalHits;
  final int totalPages;
  final int page;

  static SearchResult fromSnapshot(AlgoliaQuerySnapshot snap) {
    return SearchResult(
        courses: snap.hits.map((hit) => Course.fromJson(hit.data)),
        page: snap.page,
        totalHits: snap.nbHits,
        totalPages: snap.nbPages);
  }
}
