import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';

import 'package:course_gnome_data/models.dart';

import 'package:course_gnome/state/scheduling/scheduling.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({@required this.scheduleRepository});

  final ScheduleRepository scheduleRepository;

  @override
  void onTransition(Transition<ScheduleEvent, ScheduleState> transition) {
    // print('Schedule transition:  $transition');
  }

  @override
  ScheduleState get initialState => SchedulesLoading();

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    if (event is OfferingToggled) {
      yield SchedulesLoaded(
          scheduleRepository.toggleOffering(event.coloredOffering));
    }
    if (event is SwitchSeason) {
      scheduleRepository.season = event.season;
      dispatch(FetchSchedules());
    }
    if (event is SwitchSchool) {
      scheduleRepository.switchSchool(event.school);
      dispatch(FetchSchedules());
    }
    if (event is FetchSchedules) {
      yield SchedulesLoading();
      try {
        final Schedules schedules = await scheduleRepository.getAllSchedules();
        if (schedules == null) {
          scheduleRepository.schedulesHistory =
              SchedulesHistory.init(id: 'foo');
          // final String id = await scheduleRepository.addSchedule(
          //   scheduleName: Schedule.defaultScheduleName,
          // );
          // scheduleRepository.schedulesHistory = SchedulesHistory.init(id: id);
        } else {
          scheduleRepository.schedulesHistory = SchedulesHistory([schedules]);
        }
        yield SchedulesLoaded(scheduleRepository.schedulesHistory.current);
      } catch (e) {
        yield e is ScheduleLoadError
            ? e
            : ScheduleLoadError('Failed to load schedules');
      }
    }
    if (event is OpenDialog && currentState is SchedulesLoaded) {
      yield DialogOpen((currentState as SchedulesLoaded).schedules);
    }
    if (event is CloseDialog && currentState is DialogState) {
      yield SchedulesLoaded((currentState as DialogState).schedules);
    }

    if (event is ScheduleAdded && currentState is DialogState) {
      yield DialogLoading((currentState as DialogState).schedules);
      try {
        final String id = await scheduleRepository.addSchedule(
          scheduleName: event.scheduleName,
        );
        scheduleRepository.schedulesHistory.addSchedule(event.scheduleName, id);
        yield SchedulesLoaded(scheduleRepository.schedulesHistory.current);
      } catch (e) {
        yield DialogError((currentState as DialogState).schedules);
      }
    }

    if (event is ScheduleDeleted && currentState is DialogState) {
      yield DialogLoading((currentState as DialogState).schedules);
      try {
        await scheduleRepository.deleteSchedule(
          scheduleId: event.scheduleId,
        );
        scheduleRepository.schedulesHistory.deleteSchedule(event.scheduleId);
        yield SchedulesLoaded(scheduleRepository.schedulesHistory.current);
      } catch (e) {
        yield DialogError((currentState as DialogState).schedules);
      }
    }

    if (event is ScheduleNameEdited && currentState is DialogState) {
      yield DialogLoading((currentState as DialogState).schedules);
      try {
        await scheduleRepository.updateSchedule(
          name: event.name,
        );
        scheduleRepository.schedulesHistory.editScheduleName(event.name);
        yield SchedulesLoaded(scheduleRepository.schedulesHistory.current);
      } catch (e) {
        yield DialogError((currentState as DialogState).schedules);
      }
    }
  }
}

abstract class ScheduleEvent {}

class FetchSchedules extends ScheduleEvent {}

class Undo extends ScheduleEvent {}

class Redo extends ScheduleEvent {}

class OpenDialog extends ScheduleEvent {}

class CloseDialog extends ScheduleEvent {}

class SwitchSeason extends ScheduleEvent {
  SwitchSeason(this.season);
  final Season season;
}

class SwitchSchool extends ScheduleEvent {
  SwitchSchool(this.school);
  final School school;
}

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
  OfferingToggled({this.coloredOffering});
  final ColoredOffering coloredOffering;
}

class OfferingHovered extends ScheduleEvent {
  OfferingHovered({this.coloredOffering});
  ColoredOffering coloredOffering;
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
