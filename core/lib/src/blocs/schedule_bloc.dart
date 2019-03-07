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
        if (event.userId == null) {
          final schedules = Schedules()..addSchedule('My Schedule');
          yield SchedulesLoaded(schedules);
          return;
        }
        yield SchedulesLoading();
        try {
          final Schedules schedules =
              await schedule_repo.allSchedules(userId: event.userId);
          yield SchedulesLoaded(schedules);
        } catch (e) {
          yield e is ScheduleLoadError
              ? e
              : ScheduleLoadError('Failed to load schedules');
        }
      }
      if (currentState is SchedulesLoaded) {
        if (event is ScheduleAdded) {
          if (event.userId != null) {
            schedule_repo.addSchedule(
              userId: event.userId,
              scheduleName: event.scheduleName,
            );
          }
          final schedules = currentState.schedules
            ..addSchedule(event.scheduleName);
          yield SchedulesLoaded(schedules);
        }
        if (event is ScheduleDeleted) {
          if (event.userId != null) {
            schedule_repo.deleteSchedule(
                userId: event.userId, scheduleId: event.scheduleId);
          }
          final schedules = currentState.schedules
            ..removeSchedule(event.scheduleId);
          yield SchedulesLoaded(schedules);
        }
        if (event is OfferingToggled) {
          final schedules = currentState.schedules
            ..currentSchedule.toggleOffering(event.offering, event.color);
          if (event.userId != null) {
            schedule_repo.updateSchedule(
              userId: event.userId,
              scheduleId: currentState.schedules.currentSchedule.id,
              offerings: schedules.currentSchedule.colors,
            );
          }
          yield SchedulesLoaded(schedules);
        }
      }
    }
  }
}

class ScheduleEvent extends Equatable {
  ScheduleEvent([List props = const [], this.userId]) : super([props]);
  final String userId;
}

class FetchSchedules extends ScheduleEvent {
  FetchSchedules({@required String userId}) : super([userId], userId);
}

class ScheduleAdded extends ScheduleEvent {
  ScheduleAdded({@required this.scheduleName, @required String userId})
      : super([scheduleName], userId);
  final String scheduleName;
}

class ScheduleDeleted extends ScheduleEvent {
  ScheduleDeleted({@required this.scheduleId, @required String userId})
      : super([scheduleId], userId);
  final String scheduleId;
}

class OfferingToggled extends ScheduleEvent {
  OfferingToggled({
    @required this.offering,
    @required this.color,
    @required String userId,
  }) : super([offering, color], userId);
  final Offering offering;
  final Color color;
}

class ScheduleState extends Equatable {
  ScheduleState([List props = const [], this.schedules]) : super(props);
  final Schedules schedules;
}

class SchedulesLoading extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  SchedulesLoaded(Schedules schedules) : super([schedules], schedules);
}

class ScheduleLoadError extends ScheduleState {
  ScheduleLoadError(this.message) : super([message]);
  final String message;
}
