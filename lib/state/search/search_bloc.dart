import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:course_gnome/state/search/search.dart';

class SearchBloc extends Bloc<SearchChanged, SearchState> {
  SearchBloc({@required this.searchRepository});

  final SearchRepository searchRepository;

  @override
  Stream<SearchState> transformEvents(Stream<SearchChanged> events,
      Stream<SearchState> Function(SearchChanged event) next) {
    return (events as Observable<SearchChanged>)
        .debounceTime(Duration(milliseconds: 500))
        .switchMap(next);
  }

  @override
  void onTransition(Transition<SearchChanged, SearchState> transition) {
    print('Search transition:  $transition');
  }

  @override
  SearchState get initialState => SearchEmpty(Query());

  @override
  Stream<SearchState> mapEventToState(
    SearchChanged event,
  ) async* {
    if (event is SearchChanged) {
      final newQuery = transformQuery(currentState.query, event.queryUpdate);
      if (newQuery.isEmpty) {
        yield SearchEmpty(Query());
      } else {
        yield SearchLoading(newQuery);
        try {
          // final results = await searchRepository.search(newQuery);
          // yield SearchSuccess(results, newQuery);
          yield SearchSuccess(SearchResult(), newQuery);
        } catch (error) {
          yield error is SearchError
              ? SearchError(error.message, newQuery)
              : SearchError('something went wrong', newQuery);
        }
      }
    }
  }

  Query transformQuery(Query cq, Query qu) {
    if (qu.statuses != null) {}
    return Query(
      school: qu.school ?? cq.school,
      season: qu.season ?? cq.season,
      text: qu.text ?? cq.text,
      departments: qu.departments ?? cq.departments,
      statuses: qu.statuses ?? cq.statuses,
      minDepartmentNumber: qu.minDepartmentNumber ?? cq.minDepartmentNumber,
      maxDepartmentNumber: qu.maxDepartmentNumber ?? cq.maxDepartmentNumber,
      earliestStartTime: qu.earliestStartTime ?? cq.earliestStartTime,
      latestEndTime: qu.latestEndTime ?? cq.latestEndTime,
      u: qu.u ?? cq.u,
      m: qu.m ?? cq.m,
      t: qu.t ?? cq.t,
      w: qu.w ?? cq.w,
      r: qu.r ?? cq.r,
      f: qu.f ?? cq.f,
      s: qu.s ?? cq.s,
    );
  }
}

class SearchChanged {
  SearchChanged(this.queryUpdate);
  final Query queryUpdate;
}

class SearchState {
  SearchState(this.query);
  final Query query;
}

class SearchEmpty extends SearchState {
  SearchEmpty(Query query) : super(query);
}

class SearchLoading extends SearchState {
  SearchLoading(Query query) : super(query);
}

class SearchError extends SearchState {
  SearchError(this.message, Query query) : super(query);
  final String message;
}

class SearchSuccess extends SearchState {
  SearchSuccess(this.searchResult, Query query) : super(query);
  final SearchResult searchResult;
}
