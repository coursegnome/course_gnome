import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';

import 'package:course_gnome/state/auth/auth.dart';
import 'package:course_gnome/state/shared/models/course.dart';

class AuthRepository {
  AuthRepository({@required this.userRepository})
      : assert(userRepository != null);

  static String tag = 'AuthRepository';

  UserRepository userRepository;

  Future<User> init() async {
    print('$tag - init');
    await userRepository.init();
    if (userRepository.isAuthenticated) {
      print('$tag - init - authed, getting user from db');
      return await _getUserData();
    }
    print('$tag - init - not authed, creating anon user');
    await _signUpAnonymously();
    print('$tag - init - done');
    return null;
  }

  Future<void> _signUpAnonymously() async {
    print('$tag - signUpAnon');
    final Map response = await authPost(
      endpoint: 'signupNewUser',
      body: <String, dynamic>{'returnSecureToken': true},
    );
    print('$tag - signUpAnon - set new auth');
    userRepository.setNewAuth(response);
    print('$tag - signUpAnon - uploading user');
    await patchDoc(
      idToken: await userRepository.idToken,
      path: 'users/${userRepository.uid}',
      fields: <String, dynamic>{
        'isAnonymous': true,
      },
    );
    print('$tag - signUpAnon - done');
  }

  Future<User> signIn({
    @required String username,
    @required String password,
    @required School school,
  }) async {
    print('$tag - signIn');
    try {
      await authPost(
        endpoint: 'verifyPassword',
        body: <String, dynamic>{
          'returnSecureToken': true,
          'email': '$username@${school.domain}',
          'password': password,
        },
      );
      print('$tag - signIn - done');
      return await _getUserData();
    } catch (e) {
      rethrow;
    }
  }

  /// Link anon account with email or Google Auth
  Future<User> signUp({
    String credential,
    String username,
    String password,
    @required School school,
    @required UserType userType,
    String displayName,
    int year,
  }) async {
    print('$tag - signUp');
    final bool emailSignIn = credential == null;
    print('$tag - signUp - w/ email: $emailSignIn');
    try {
      final String email = '$username@${school.domain}';
      final Map<String, dynamic> body = emailSignIn
          ? <String, dynamic>{
              'returnSecureToken': true,
              'email': email,
              'password': password,
            }
          : <String, dynamic>{
              'returnSecureToken': true,
              'postBody': {'id_token': credential, 'providerId': 'google.com'}
            };
      print('$tag - signUp - sending request');
      final Map response = await authPost(
        endpoint: emailSignIn ? 'setAccountInfo' : 'verifyAssertion',
        body: body,
        idToken: await userRepository.idToken,
      );
      await _sendVerificationEmail();
      userRepository.setNewAuth(response);
      User user = userType == UserType.Student
          ? Student(
              advisors: [],
              displayName: displayName,
              email: email,
              emailVerified: false,
              school: school,
              username: username,
              userType: UserType.Student,
              year: year,
            )
          : Advisor(
              advisees: [],
              displayName: displayName,
              email: email,
              emailVerified: false,
              school: school,
              username: username,
              userType: UserType.Student,
            );
      print('$tag - signUp - uploading user');
      await patchDoc(
        idToken: await userRepository.idToken,
        path: 'users/${userRepository.uid}',
        updateMask: [
          'isAnonymous',
          'school',
          'displayName',
          'year',
          'username',
          'id',
          'email',
          'emailVerified',
          'userType'
        ],
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
//      await deleteDoc(
//        path: 'users/${userRepository.uid}',
//      );
    } catch (e) {
      rethrow;
    }
  }
}
