import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:color/color.dart';

import 'package:core/core.dart';
import 'package:core/src/data/schedule_repository.dart' as schedule_repo;
import 'package:equatable/equatable.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc();

  @override
  Stream<ScheduleEvent> transform(Stream<ScheduleEvent> events) {
    return (events as Observable<ScheduleEvent>)
        .debounce(Duration(milliseconds: 500));
  }

  @override
  void onTransition(Transition<ScheduleEvent, ScheduleState> transition) {
    print('Schedule transition:  $transition');
  }

  @override
  ScheduleState get initialState => SchedulesLoading();

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleState currentState,
    ScheduleEvent event,
  ) async* {
    if (event is ScheduleEvent) {
      if (event is FetchSchedules) {
        yield SchedulesLoading();
        final Schedules schedules =
            await schedule_repo.allSchedules(userId: event.userId);
        yield NormalState(schedules);
      }
      if (event is ScheduleAdded) {
        yield ScheduleTransactionOngoing();
        try {
          await schedule_repo.addSchedule(
            userId: event.userId,
            scheduleName: event.scheduleName,
          );
          if (currentState is NormalState) {
            yield NormalState(currentState.schedules);
          }
        } catch (e) {
          yield e is ScheduleTransactionError
              ? ScheduleTransactionError(e.message)
              : ScheduleTransactionError('something went wrong');
        }
      }
    }
  }
}

class ScheduleEvent extends Equatable {
  ScheduleEvent([
    this.userId,
    List props = const [],
  ]) : super([props]);
  final String userId;
}

class FetchSchedules extends ScheduleEvent {}

class ScheduleAdded extends ScheduleEvent {
  ScheduleAdded({
    @required this.scheduleName,
    @required String userId,
  }) : super(userId, [scheduleName]);
  final String scheduleName;
}

class ScheduleDeleted extends ScheduleEvent {
  ScheduleDeleted({
    @required this.id,
    @required String userId,
  }) : super(userId, [id]);
  final String id;
}

class ScheduleUpdated extends ScheduleEvent {
  ScheduleUpdated({
    @required this.scheduleName,
    @required this.offerings,
    @required String userId,
  }) : super(userId, [scheduleName, offerings]);
  final String scheduleName;
  final Map<String, Color> offerings;
}

class ScheduleState extends Equatable {
  ScheduleState([this.schedules, List props = const []]) : super(props);
  final Schedules schedules;
}

class SchedulesLoading extends ScheduleState {}

class NormalState extends ScheduleState {}

class ScheduleLoadError extends ScheduleState {
  ScheduleLoadError(this.message) : super([message]);
  final String message;
}

class ScheduleTransactionOngoing extends ScheduleState {}

class ScheduleTransactionError extends ScheduleState {
  ScheduleTransactionError(this.message) : super([message]);
  final String message;
}
