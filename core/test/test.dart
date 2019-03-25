@TestOn('vm')

import 'package:test/test.dart';
import 'package:color/color.dart';
import 'package:core/core.dart';

void main() {
  test('Schedules History', () {
    // Init
    final SchedulesHistory schedulesHistory = SchedulesHistory();
    expect(schedulesHistory.currentHistoryIndex, 0);
    expect(schedulesHistory.current.schedules.length, 1);
    expect(schedulesHistory.current.schedules.first.name,
        Schedule.defaultScheduleName);

    // Add
    schedulesHistory.addSchedule('My Schedule', '1');
    expect(schedulesHistory.currentHistoryIndex, 1);
    expect(schedulesHistory.current.schedules.length, 2);
    expect(schedulesHistory.current.currentScheduleIndex, 1);

    // Undo
    schedulesHistory.undo();
    expect(schedulesHistory.currentHistoryIndex, 0);
    expect(schedulesHistory.current.schedules.length, 1);
    expect(schedulesHistory.current.currentScheduleIndex, 0);

    // Redo
    schedulesHistory.redo();
    expect(schedulesHistory.currentHistoryIndex, 1);
    expect(schedulesHistory.current.schedules.length, 2);
    expect(schedulesHistory.current.currentScheduleIndex, 1);

    // Toggle
    final Offering offering =
        Offering(id: '12212', sectionNumber: '10', status: Status.Waitlist);
    final Color color = Color.hex('ffffff');
    schedulesHistory.toggleOffering(offering, color);
    expect(schedulesHistory.currentHistoryIndex, 2);
    expect(schedulesHistory.current.schedules.length, 2);
    expect(schedulesHistory.current.schedules[1].offerings.first.offering.id,
        '12212');
    expect(schedulesHistory.current.currentScheduleIndex, 1);

    // Delete
    schedulesHistory.deleteSchedule('1');
    expect(schedulesHistory.currentHistoryIndex, 3);
    expect(schedulesHistory.current.schedules.length, 1);
    expect(schedulesHistory.current.currentScheduleIndex, 0);

    // Undo and overwrite history
    schedulesHistory.undo();
    schedulesHistory.undo();
    expect(schedulesHistory.currentHistoryIndex, 1);
    schedulesHistory.addSchedule('New Schedule', '3');
    expect(schedulesHistory.currentHistoryIndex, 2);

    // Add schedule with existing ID
    expect(
      () => schedulesHistory.addSchedule('Exists', '3'),
      throwsArgumentError,
    );

    // Edit name
    schedulesHistory.editScheduleName('New Name');
    expect(schedulesHistory.current.schedules[2].name, 'New Name');
  });

  group('Schedule Repo', () {
    final scheduleRepo = ScheduleRepository();
    test('All Schedules', () async {
      await scheduleRepo.getAllSchedules();
    });
  });

//  group('Scheduling Bloc', () {
//    test('Not Logged In', () {
//      final ScheduleBloc bloc = ScheduleBloc();
//
//      expect(bloc.initialState, SchedulesLoading());
//
//      expectLater(
//        bloc.state,
//        emitsInOrder(
//          [
//            SchedulesLoading(),
//            SchedulesLoaded(
//              Schedules(schedules: [Schedule(name: 'My Schedule', id: '0')]),
//            ),
//            SchedulesLoaded(
//              Schedules(schedules: [
//                Schedule(name: 'My Schedule', id: '0'),
//                Schedule(name: 'New Schedule', id: '1'),
//              ]),
//            ),
//          ],
//        ),
//      );
//
//      bloc.dispatch(FetchSchedules(userId: null));
//      bloc.dispatch(ScheduleAdded(scheduleName: 'New Schedule', userId: null));
////      Future.delayed(Duration(milliseconds: 100)).then((x) {
////        bloc.dispatch(
////            ScheduleAdded(scheduleName: 'New Schedule', userId: null));
////      });
//    });
//  });
}
