import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:course_gnome/state/search/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({@required this.searchRepository});

  final SearchRepository searchRepository;

  // Debounce text, course number, time
  bool _shouldDebounceEvent(SearchEvent event) {
    if (event is LoadMoreResults) {
      return false;
    }
    if (event is SearchChanged) {
      return (event.queryUpdate.text != null ||
          event.queryUpdate.minDepartmentNumber != null ||
          event.queryUpdate.maxDepartmentNumber != null ||
          event.queryUpdate.earliestStartTime != null ||
          event.queryUpdate.latestEndTime != null);
    }
    return false;
  }

  @override
  Stream<SearchState> transformEvents(Stream<SearchEvent> events,
      Stream<SearchState> Function(SearchEvent event) next) {
    final observableStream = events as Observable<SearchEvent>;
    final nonDebounceStream =
        observableStream.where((event) => !_shouldDebounceEvent(event));
    final debounceStream = observableStream
        .where((event) => _shouldDebounceEvent(event))
        .debounceTime(Duration(milliseconds: 500));
    return nonDebounceStream.mergeWith([debounceStream]).switchMap(next);
  }

  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    // print(transition.currentState.query.toString());
  }

  @override
  SearchState get initialState => SearchEmpty(Query.initial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchChanged) {
      final newQuery = transformQuery(currentState.query, event.queryUpdate);
      if (newQuery.isEmpty) {
        yield SearchEmpty(newQuery);
      } else {
        yield SearchLoading(newQuery);
        try {
          final result = await searchRepository.search(newQuery);
          yield SearchSuccess(result, newQuery);
        } catch (error) {
          yield error is SearchError
              ? SearchError(error.message, newQuery)
              : SearchError('something went wrong', newQuery);
        }
      }
    }
    if (event is LoadMoreResults) {
      yield LoadMoreLoading(
        (currentState as SearchSuccess).searchResult,
        (currentState as SearchSuccess).query,
      );
      final SearchResult result = await searchRepository.loadMore();
      yield SearchSuccess(result, currentState.query);
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

class SearchEvent {}

class SearchChanged extends SearchEvent {
  SearchChanged(this.queryUpdate);
  final Query queryUpdate;
}

class LoadMoreResults extends SearchEvent {}

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

class LoadMoreLoading extends SearchState {
  LoadMoreLoading(this.searchResult, Query query) : super(query);
  final SearchResult searchResult;
}

class SearchError extends SearchState {
  SearchError(this.message, Query query) : super(query);
  final String message;
}

class SearchSuccess extends SearchState {
  SearchSuccess(this.searchResult, Query query) : super(query);
  final SearchResult searchResult;
}
