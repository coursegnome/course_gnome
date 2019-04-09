@TestOn('vm')

import 'package:test/test.dart';
import 'package:core/core.dart';

void main() {
  UserAuth stored;
  User user;

  Future<void> _storeTokens(UserAuth tokens) async => stored = tokens;
  Future<UserAuth> _getTokens() async => stored;

  final UserRepository userRepository = UserRepository(
    getStoredTokensCallback: _getTokens,
    storeTokensCallback: _storeTokens,
  );

  final authRepo = AuthRepository(userRepository: userRepository);

  group('Auth Repository', () {
    test('Init', () async {
      user = await authRepo.init();
      expect(user, isNull);
      expect(userRepository.isAuthenticated, true);
    });

    test('Sign up wfrom anon', () async {
      user = await authRepo.signUp(
        username: 'timtraversy',
        password: 'test123',
        school: School.gwu,
        userType: UserType.Student,
        year: 4,
        displayName: 'Tim Traversy',
      );
      expect(user, isNotNull);
      expect(user.email, 'timtraversy@gwmail.gwu.edu');
      expect(user.emailVerified, false);
    });

    test('Signed in on init', () async {
      user = await authRepo.init();
      expect(user.username, 'timtraversy');
      expect(user.displayName, 'Tim Traversy');
      expect(user.school, School.gwu);
      expect(user.userType, UserType.Student);
      expect(user.emailVerified, false);
      expect(user.email, 'timtraversy@gwmail.gwu.edu');
    });

    test('getAllSchedules', () async {
      final scheduleRepo = ScheduleRepository(
        userRepository: userRepository,
        school: School.gwu,
        season: Season.fall2019,
      );
      final Schedules schedules = await scheduleRepo.getAllSchedules();
      expect(schedules, isNull);
      final id = await scheduleRepo.addSchedule(scheduleName: 'Hello');
    });
  });

  group('Schedule Repo', () {});

  test('Tear down', () async {
    await authRepo.deleteUser();
  });
}
