@TestOn('vm')

import 'package:test/test.dart';
import 'package:core/core.dart';

void main() {
  test('Schedules Model', () {
    final schedules = Schedules(list: []);
    schedules.addSchedule('My Schedule');
    expect(schedules.list.length, equals(1));
    expect(schedules.list.first.name, equals('My Schedule'));
    expect(schedules.currentScheduleIndex, equals(1));

    schedules.removeSchedule('My Schedule');
    expect(schedules.list.length, equals(1));
    expect(schedules.list.first.name, equals('My Schedule'));
    expect(schedules.currentScheduleIndex, equals(1));
  });
//  group('Schedlue', () {
//    test('Create', () {
//      final bloc = ScheduleBloc();
//      final List<Schedules> states = [
//        Schedules(
//
//        ),
//      ];
//      expect(bloc.initialState, SchedulesLoading());
//      bloc.dispatch(FetchSchedules(userId: null));
//      expect(bloc.currentState.schedules.list.length, equals(1));
//      expect(bloc.currentState.schedules.c, equals(1));
//    });
//  });
//  group('Schedluing bloc', () {
//    test('Not signed in', () {
//      final bloc = ScheduleBloc();
//      final List<Schedules> states = [
//        Schedules(
//
//        ),
//      ];
//      expect(bloc.initialState, SchedulesLoading());
//      bloc.dispatch(FetchSchedules(userId: null));
//      expect(bloc.currentState.schedules.list.length, equals(1));
//      expect(bloc.currentState.schedules.c, equals(1));
//    });
//  });
}
