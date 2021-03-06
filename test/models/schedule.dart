import 'package:flutter/rendering.dart';
@TestOn('vm')
import 'package:test/test.dart';
import 'package:course_gnome_data/models.dart';
import 'package:course_gnome/state/scheduling/scheduling.dart';

void main() {
  test('Schedules History', () {
    // Init
    final SchedulesHistory schedulesHistory = SchedulesHistory.init();
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
        Offering(id: '12212', section: '10', status: Status.Waitlist);
    final ColoredOffering coloredOffering = ColoredOffering(
      color: Color(0xffffffff),
      offering: offering,
    );
    schedulesHistory.toggleOffering(coloredOffering);
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
}
