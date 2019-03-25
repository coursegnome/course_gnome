import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:color/color.dart';

import 'package:core/core.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({this.authBloc, this.scheduleRepository}) {
    authSub = authBloc.state.listen((state) {
      if (state is LoggedIn) {
        user = state.user;
        dispatch(FetchSchedules());
      }
    });
  }

  final AuthBloc authBloc;
  final ScheduleRepository scheduleRepository;
  User user;
  StreamSubscription authSub;

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
  void dispose() {
    authSub.cancel();
    super.dispose();
  }

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleState currentState,
    ScheduleEvent event,
  ) async* {
    if (event is ScheduleEvent) {
      if (event is FetchSchedules) {
        yield SchedulesLoading();
        try {
          if (user.isAnonymous) {
            final String id = await scheduleRepository.addSchedule(
                scheduleName: Schedule.defaultScheduleName);
            user.schedulesHistory = SchedulesHistory.init(id: id);
          } else {
            final Schedules schedules =
                await scheduleRepository.getAllSchedules();
            user.schedulesHistory = SchedulesHistory(schedules: schedules);
          }
          yield SchedulesLoaded(user.schedulesHistory.current);
        } catch (e) {
          yield e is ScheduleLoadError
              ? e
              : ScheduleLoadError('Failed to load schedules');
        }
      }
      if (event is OpenDialog && currentState is SchedulesLoaded) {
        yield DialogOpen(currentState.schedules);
      }
      if (event is CloseDialog && currentState is DialogState) {
        yield SchedulesLoaded(currentState.schedules);
      }
      if (event is ScheduleAdded && currentState is DialogState) {
        yield DialogLoading(currentState.schedules);
        try {
          final String id = await scheduleRepository.addSchedule(
            scheduleName: event.scheduleName,
          );
          user.schedulesHistory.addSchedule(event.scheduleName, id);
          yield SchedulesLoaded(user.schedulesHistory.current);
        } catch (e) {
          yield DialogError(currentState.schedules);
        }
      }

      if (event is ScheduleDeleted && currentState is DialogState) {
        yield DialogLoading(currentState.schedules);
        try {
          await scheduleRepository.deleteSchedule(
            scheduleId: event.scheduleId,
          );
          user.schedulesHistory.deleteSchedule(event.scheduleId);
          yield SchedulesLoaded(user.schedulesHistory.current);
        } catch (e) {
          yield DialogError(currentState.schedules);
        }
      }

      if (event is ScheduleNameEdited && currentState is DialogState) {
        yield DialogLoading(currentState.schedules);
        try {
          await scheduleRepository.updateSchedule(
            name: event.name,
          );
          user.schedulesHistory.editScheduleName(event.name);
          yield SchedulesLoaded(user.schedulesHistory.current);
        } catch (e) {
          yield DialogError(currentState.schedules);
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

abstract class ScheduleEvent {}

class FetchSchedules extends ScheduleEvent {}

class Undo extends ScheduleEvent {}

class Redo extends ScheduleEvent {}

class OpenDialog extends ScheduleEvent {}

class CloseDialog extends ScheduleEvent {}

class ScheduleAdded extends ScheduleEvent {
  ScheduleAdded({this.scheduleName});
  final String scheduleName;
}

// TODO: SchedHist model only supports deleting/editing current sched
class ScheduleDeleted extends ScheduleEvent {
  ScheduleDeleted({@required this.scheduleId});
  final String scheduleId;
}

class ScheduleNameEdited extends ScheduleEvent {
  ScheduleNameEdited({@required this.name, this.scheduleId});
  final String name;
  final String scheduleId;
}

class OfferingToggled extends ScheduleEvent {
  OfferingToggled({@required this.offering, @required this.color, this.scheduleId});
  final Offering offering;
  final Color color;
  final String scheduleId;
}

// State
abstract class ScheduleState {}

class SchedulesLoading extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  SchedulesLoaded(this.schedules);
  final Schedules schedules;
}

class ScheduleLoadError extends ScheduleState {
  ScheduleLoadError(this.message);
  final String message;
}

class DialogState extends SchedulesLoaded {
  DialogState(Schedules schedules) : super(schedules);
}

class DialogOpen extends DialogState {
  DialogOpen(Schedules schedules) : super(schedules);
}

class DialogLoading extends DialogState {
  DialogLoading(Schedules schedules) : super(schedules);
}

class DialogError extends DialogState {
  DialogError(Schedules schedules) : super(schedules);
}
