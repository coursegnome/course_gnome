import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:core/core.dart';

class SearchBloc extends Bloc<SearchChanged, SearchState> {
  SearchBloc({@required this.searchRepository});

  final SearchRepository searchRepository;

  @override
  Stream<SearchChanged> transform(Stream<SearchChanged> events) {
    return (events as Observable<SearchChanged>)
        .debounce(Duration(milliseconds: 500));
  }

  @override
  void onTransition(Transition<SearchChanged, SearchState> transition) {
    print('Search transition:  $transition');
  }

  @override
  SearchState get initialState => SearchEmpty();

  @override
  Stream<SearchState> mapEventToState(
    SearchState currentState,
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
