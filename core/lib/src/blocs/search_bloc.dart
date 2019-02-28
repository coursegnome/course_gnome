import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

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
    print(transition);
  }

  @override
  SearchState get initialState => SearchStateEmpty();

  @override
  Stream<SearchState> mapEventToState(
    SearchState currentState,
    SearchChanged event,
  ) async* {
    if (event is SearchChanged) {
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final results = await githubRepository.search(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    }
  }
}

class SearchChanged extends Equatable {
  SearchChanged({this.query}) : super([query]);
  final Query query;
}

class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class SearchStateEmpty extends SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateError extends SearchState {
  SearchStateError(this.error) : super([error]);
  final String error;
}

class SearchStateSuccess extends SearchState {
  SearchStateSuccess(this.searchResult);
  final SearchResult searchResult;
}
