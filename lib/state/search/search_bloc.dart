import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:course_gnome/state/search/search.dart';

class SearchBloc extends Bloc<SearchChanged, SearchState> {
  SearchBloc({@required this.searchRepository});

  final SearchRepository searchRepository;

  @override
  Stream<SearchState> transformEvents(
    Stream<SearchChanged> events,
    Stream<SearchState> Function(SearchChanged event) next,
  ) {
    return (events as Observable<SearchChanged>)
        .debounceTime(
          Duration(milliseconds: 500),
        )
        .switchMap(next);
  }

  @override
  void onTransition(Transition<SearchChanged, SearchState> transition) {
    print('Search transition:  $transition');
  }

  @override
  SearchState get initialState => SearchEmpty();

  @override
  Stream<SearchState> mapEventToState(
    SearchChanged event,
  ) async* {
    if (event is SearchChanged) {
      if (event.query.isEmpty) {
        yield SearchEmpty();
      } else {
        yield SearchLoading();
        try {
          final results = await searchRepository.search(event.query);
          yield SearchSuccess(results);
        } catch (error) {
          yield error is SearchError
              ? SearchError(error.message)
              : SearchError('something went wrong');
        }
      }
    }
  }
}

class SearchChanged {
  SearchChanged(this.query);
  final Query query;
}

class SearchState {}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  SearchError(this.message);
  final String message;
}

class SearchSuccess extends SearchState {
  SearchSuccess(this.searchResult);
  final SearchResult searchResult;
}
