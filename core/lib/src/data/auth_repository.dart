import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:core/core.dart';
import 'http_wrapper.dart';

class AuthRepository {
  AuthRepository({this.userRepository});

  UserRepository userRepository;

  Future<User> init() async {
    await userRepository.init();
    if (userRepository.isAuthenticated) {
      return await _getUserData();
    }
    await signUpAnonymously();
    return null;
  }

  Future<void> signUpAnonymously() async {
    final Map response = await authPost(
      endpoint: 'signupNewUser',
      body: <String, dynamic>{'returnSecureToken': true},
    );
    userRepository.setNewAuth(response);
    await patchDoc(
      idToken: await userRepository.idToken,
      path: 'users/${userRepository.uid}',
      fields: <String, dynamic>{
        'schedules': <String, dynamic>{},
        'isAnonymous': true,
      },
    );
  }

  Future<User> signIn({
    @required String username,
    @required String password,
    @required School school,
  }) async {
    try {
      await authPost(
        endpoint: 'verifyPassword',
        body: <String, dynamic>{
          'returnSecureToken': true,
          'email': '$username@${school.domain}',
          'password': password,
        },
      );
      return await _getUserData();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> signUp({
    @required String username,
    @required String password,
    @required School school,
    @required UserType userType,
    String displayName,
    int year,
  }) async {
    try {
      final String email = '$username@${school.domain}';
      final Map response = await authPost(
        endpoint:
            userRepository.isAuthenticated ? 'setAccountInfo' : 'signupNewUser',
        body: <String, dynamic>{
          'returnSecureToken': true,
          'email': email,
          'password': password,
        },
        idToken: userRepository.isAuthenticated
            ? await userRepository.idToken
            : null,
      );
      userRepository.setNewAuth(response);
      User user;
      if (userType == UserType.Student) {
        user = Student(
          advisors: [],
          displayName: displayName,
          email: email,
          emailVerified: false,
          school: school,
          username: username,
          userType: UserType.Student,
          year: year,
        );
      } else {
        user = Advisor(
          advisees: [],
          displayName: displayName,
          email: email,
          emailVerified: false,
          school: school,
          username: username,
          userType: UserType.Student,
        );
      }
      await patchDoc(
        idToken: await userRepository.idToken,
        path: 'users/${userRepository.uid}',
        updateMask: userRepository.isAuthenticated
            ? [
                'isAnonymous',
                'school',
                'displayName',
                'year',
                'username',
                'id',
                'email',
                'emailVerified',
                'userType'
              ]
            : [],
        fields: jsonDecode(jsonEncode(user)),
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _sendVerificationEmail() async {
    await authPost(
      endpoint: 'getOobConfirmationCode',
      idToken: await userRepository.idToken,
      body: <String, dynamic>{'requestType': 'VERIFY_EMAIL'},
    );
  }

  Future<User> _getUserData() async {
    final Map response = await getDoc(
      idToken: await userRepository.idToken,
      path: 'users/${userRepository.uid}',
    );
    if (response['username'] == null) {
      return null;
    }
    return (response['userType'] == UserType.Student)
        ? Student.fromJson(response)
        : Student.fromJson(response);
  }

  Future<void> deleteUser() async {
    try {
      await authPost(
        endpoint: 'deleteAccount',
        idToken: await userRepository.idToken,
      );
      await deleteDoc(
        path: 'users/${userRepository.uid}',
      );
    } catch (e) {
      rethrow;
    }
  }
}
