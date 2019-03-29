import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:color/color.dart';

import 'package:core/core.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({this.scheduleRepository});
  /*ScheduleBloc({this.authBloc, this.scheduleRepository}) {
    authSub = authBloc.state.listen((state) {
      if (state is LoggedIn) {
        user = state.user;
        dispatch(FetchSchedules());
      }
    });
  }

  final AuthBloc authBloc;
  StreamSubscription authSub;
  */
  final ScheduleRepository scheduleRepository;
  User user;

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
    //authSub.cancel();
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
          if (event.isNewUser) {
            final String id = await scheduleRepository.addSchedule(
              scheduleName: Schedule.defaultScheduleName,
            );
            user.schedulesHistory = SchedulesHistory.init(id: id);
          } else {
            final Schedules schedules =
                await scheduleRepository.getAllSchedules();
            user.schedulesHistory = SchedulesHistory([schedules]);
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
    }
  }
}

abstract class ScheduleEvent {}

class FetchSchedules extends ScheduleEvent {
  FetchSchedules({this.user, this.isNewUser});
  final User user;
  final bool isNewUser;
}

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
  ScheduleDeleted({this.scheduleId});
  final String scheduleId;
}

class ScheduleNameEdited extends ScheduleEvent {
  ScheduleNameEdited({this.name, this.scheduleId});
  final String name;
  final String scheduleId;
}

class OfferingToggled extends ScheduleEvent {
  OfferingToggled({this.offering, this.color, this.scheduleId});
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
