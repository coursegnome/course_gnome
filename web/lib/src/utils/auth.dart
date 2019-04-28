import 'dart:html';
import 'package:core/core.dart';

Future<void> storeAuth(UserAuth auth)async {
  Storage localStorage = window.localStorage;
  localStorage.addAll({
    'idToken': auth.idToken,
    'refreshToken': auth.refreshToken,
    'expirationTime': auth.expirationTime.millisecondsSinceEpoch.toString(),
    'uid': auth.uid
  });
}

Future<UserAuth> getStoredAuth() async {
  Storage localStorage = window.localStorage;
  if (!localStorage.containsKey('idToken')) {
    return null;
  }
  return UserAuth(
    idToken: localStorage['idToken'],
    refreshToken: localStorage['refreshToken'],
    expirationTime: DateTime.fromMillisecondsSinceEpoch(
        int.parse(localStorage['expirationTime'])),
    uid: localStorage['uid'],
  );
}

bool isFirstTimeUser() => window.localStorage.containsKey('firstTime');

void setFirstTimeStatus() => window.localStorage['firstTime'] = null;
