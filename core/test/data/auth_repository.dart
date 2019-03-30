@TestOn('vm')

import 'package:test/test.dart';
import 'package:core/core.dart';

void main() {
  Tokens stored;
  User user;

  Future<void> _storeTokens(Tokens tokens) async {
    stored = tokens;
  }

  Future<Tokens> _getTokens() async => stored;

  final authRepo = AuthRepository(
    getStoredTokens: _getTokens,
    storeTokens: _storeTokens,
    school: School.gwu,
  );

  test('Init', () async {
    user = await authRepo.init();
    expect(user, isNotNull);
  });

  test('Sign up from anon', () async {
    user = await authRepo.signUp(
      username: 'timtraversy',
      password: 'test123',
    );
    expect(user, isNotNull);
    expect(user.email, 'timtraversy@gwmail.gwu.edu');
    expect(user.emailVerified, false);
  });

  test('Signed in on init', () async {
    user = await authRepo.init();
    expect(user.email, 'timtraversy@gwmail.gwu.edu');
    await authRepo.deleteUser();
  });
}
