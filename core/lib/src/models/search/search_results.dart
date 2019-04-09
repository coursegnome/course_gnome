import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:core/core.dart';
import 'package:algolia/algolia.dart';

class SearchResult {
  SearchResult({
    @required this.courses,
    @required this.totalPages,
    this.page = 0,
    this.queue,
  });

  final int totalPages;
  final int page;
  final List<List<Offering>> courses;
  final ListQueue<Offering> queue;

  bool get isMaxedOut => page + 1 == totalPages;

  static SearchResult fromSnapshot([
    AlgoliaQuerySnapshot snap,
    SearchResult currentResult,
  ]) {
    final ListQueue<Offering> queue = currentResult?.queue ?? ListQueue()
      ..addAll(snap.hits.map((hit) => Offering.fromJson(hit.data)).toList());

    bool sameAsFirst(Offering offering) => queue.first.inSameClassAs(offering);

    final List<List<Offering>> courses = currentResult?.courses ?? [];

    if (queue.isNotEmpty) {
      while (!queue.every((offering) => sameAsFirst(offering)) ||
          (snap.page == snap.nbPages - 1 && queue.isNotEmpty)) {
        courses.add(queue.where((offering) => sameAsFirst(offering)).toList());
        final Offering course = queue.first;
        queue.removeWhere((offering) => offering.inSameClassAs(course));
      }
    }

    return SearchResult(
      queue: queue,
      totalPages: snap.nbPages,
      page: snap.page,
      courses: courses,
    );
  }
}
