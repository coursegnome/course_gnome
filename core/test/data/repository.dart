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

    test('Sign up from anon', () async {
      user = await authRepo.signUp(
          username: 'timtraversy',
          password: 'test123',
          school: School.gwu,
          userType: UserType.Student,
          year: 4,
          displayName: 'Tim Traversy',);
      expect(user, isNotNull);
      expect(user.email, 'timtraversy@gwmail.gwu.edu');
      expect(user.emailVerified, false);
    });

    test('Signed in on init', () async {
      user = await authRepo.init();
      expect(user.email, 'timtraversy@gwmail.gwu.edu');
      await authRepo.deleteUser();
    });
  });
}
