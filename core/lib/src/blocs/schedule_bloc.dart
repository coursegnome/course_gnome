import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:color/color.dart';

import 'package:core/core.dart';
import 'package:core/src/data/schedule_repository.dart' as schedule_repo;
import 'package:equatable/equatable.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc();
  SchedulesHistory schedulesHistory;

//  @override
//  Stream<ScheduleEvent> transform(Stream<ScheduleEvent> events) {
//    return (events as Observable<ScheduleEvent>)
//        .debounce(Duration(milliseconds: 500));
//  }

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
        try {
          if (event.isAnonymous) {
            final String id = await schedule_repo.addSchedule(
                userId: event.userId,
                scheduleName: Schedule.defaultScheduleName);
            schedulesHistory = SchedulesHistory(
                schedules: Schedules(schedules: [
              Schedule(
                  name: Schedule.defaultScheduleName, id: id, offerings: {})
            ]));
          } else {
            final Schedules schedules =
                await schedule_repo.allSchedules(userId: event.userId);
            schedulesHistory = SchedulesHistory(schedules: schedules);
          }
          yield SchedulesLoaded(schedulesHistory.current);
        } catch (e) {
          yield e is ScheduleLoadError
              ? e
              : ScheduleLoadError('Failed to load schedules');
        }
      }
//      if (currentState is SchedulesLoaded) {
//        if (event is ScheduleAdded) {
//          schedulesHistory.addSchedule(event.scheduleName, id);
//          schedules.addSchedule(name: event.scheduleName, id: id);
//          yield SchedulesLoaded(schedules);
//          if (event.userId != null) {
//            schedule_repo.addSchedule(
//              userId: event.userId,
//              scheduleId: id,
//              scheduleName: event.scheduleName,
//            );
//          }
//        }
//        if (event is ScheduleDeleted) {
//          yield SchedulesLoaded(
//            currentState.schedules..removeSchedule(id: event.scheduleId),
//          );
//          if (event.userId != null) {
//            schedule_repo.deleteSchedule(
//                userId: event.userId, scheduleId: event.scheduleId);
//          }
//        }
//        if (event is OfferingToggled) {
//          final schedules = currentState.schedules
//            ..currentSchedule.toggleOffering(event.offering, event.color);
//          yield SchedulesLoaded(schedules);
//          if (event.userId != null) {
//            schedule_repo.updateSchedule(
//              userId: event.userId,
//              scheduleId: currentState.schedules.currentSchedule.id,
//              offerings: schedules.currentSchedule.colorMap,
//            );
//          }
//        }
//      }
    }
  }
}

class ScheduleEvent extends Equatable {
  ScheduleEvent([List props = const [], this.userId]) : super([props, userId]);
  final String userId;
}

class FetchSchedules extends ScheduleEvent {
  FetchSchedules({@required String userId, @required this.isAnonymous})
      : super([isAnonymous], userId);
  final bool isAnonymous;
}

class Undo extends ScheduleEvent {}

class Redo extends ScheduleEvent {}

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

class ScheduleNameEdited extends ScheduleEvent {
  ScheduleNameEdited({
    @required this.name,
    @required String userId,
  }) : super([name], userId);
  final String name;
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
  ScheduleState([List props = const []]) : super(props);
}

class SchedulesLoading extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  SchedulesLoaded(this.schedules) : super([schedules]);
  final Schedules schedules;
}

class ScheduleLoadError extends ScheduleState {
  ScheduleLoadError(this.message) : super();
  final String message;
}
