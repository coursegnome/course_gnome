import 'dart:collection';

import 'package:algolia/algolia.dart';
import 'package:meta/meta.dart';

import 'package:course_gnome_data/models.dart';

class SearchResult {
  SearchResult({
    @required this.courses,
    @required this.moreResults,
  });
  final List<List<Offering>> courses;
  final bool moreResults;
}

class CachedSearchResult {
  CachedSearchResult({this.result, this.totalPages, this.page, this.queue});
  final SearchResult result;
  final int totalPages;
  final int page;
  final ListQueue<Offering> queue;

  bool get isMaxedOut => page == totalPages - 1;

// Pull courses into queue. Construct list of lists of offerings for each course.
// Whatever isn't used is left in the queue for the next pull.
  static CachedSearchResult fromSnapshot({
    AlgoliaQuerySnapshot snap,
    CachedSearchResult currentResult,
  }) {
    // Add all hits to queue as Offerings
    final ListQueue<Offering> queue = currentResult?.queue ?? ListQueue()
      ..addAll(snap.hits.map((hit) => Offering.fromJson(hit.data)).toList());

    // Create courses array
    final List<List<Offering>> courses = currentResult?.result?.courses ?? [];

    // Pop off offerings and combine them into courses
    bool someOfferingsInDifferentClass() =>
        queue.any((offering) => !queue.first.inSameClassAs(offering));
    bool onLastPage() => snap.page == snap.nbPages - 1 && queue.isNotEmpty;

    while (someOfferingsInDifferentClass() || onLastPage()) {
      final firstOffering = queue.removeFirst();
      final List<Offering> course = [firstOffering];
      if (queue.isNotEmpty) {
        while (queue.first.inSameClassAs(firstOffering)) {
          course.add(queue.removeFirst());
        }
      }
      courses.add(course);
    }

    return CachedSearchResult(
      queue: queue,
      totalPages: snap.nbPages,
      page: snap.page,
      result: SearchResult(
        moreResults: snap.nbPages - 1 == snap.page,
        courses: courses,
      ),
    );
  }
}
