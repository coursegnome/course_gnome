@Timeout(Duration(minutes: 2))
import 'package:test/test.dart';
import 'package:core/core.dart';

void main() {
  final Query query = Query(
    school: School.gwu,
    season: Season.fall2019,
    text: null,
    departments: ['SMPA'],
//    statuses: [Status.Open],
//    minDepartmentNumber: 1000,
//    maxDepartmentNumber: 3000,
//    earliestStartTime: TimeOfDay(hour: 11, minute: 30),
//    latestEndTime: TimeOfDay(hour: 16, minute: 40),
//    u: true,
//    m: true,
//    t: true,
//    w: true,
//    r: true,
//    f: true,
//    s: true,
  );

  group('Class utilites', () {
    final Query empty = Query();

    test('Equatable', () {
      expect(query, query);
    });
    test('Is empty', () {
      expect(query.isEmpty, false);
      expect(empty.isEmpty, true);
    });
    test('To string', () {});
  });

  group('Repository', () {
    final SearchRepository repo = SearchRepository();
    test('Search', () async {
      SearchResult res = await repo.search(query);
      while (!res.isMaxedOut) {
        res = await repo.loadMore(query);
      }
      for (final List list in res.offerings) {
        for (final Offering o in list) {
          print(o.name + ' - ' + list.length.toString());
        }
      }
    });
  });
}
