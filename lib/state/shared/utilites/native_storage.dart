@JS()
library storage;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:js/js.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:course_gnome/state/auth/auth.dart';
import 'package:course_gnome/state/scheduling/scheduling.dart';

external Storage get localStorage;

@JS()
class Storage {
  int length;
  external dynamic getItem(String key);
  external void setItem(String key, dynamic item);
  external void removeItem(String key);
  external void clear();
}

const String schedulesKey = 'schedules';

Future<Schedules> getStoredSchedules() async {
  if (kIsWeb) {
    final schedulesJson = localStorage.getItem(schedulesKey);
    if (schedulesJson == null) {
      return null;
    }
    return jsonDecode(localStorage.getItem(schedulesKey));
  }
  return null;
}

Future<void> storeSchedules(Schedules schedules) async {
  if (kIsWeb) {
    localStorage.setItem(schedulesKey, jsonEncode(schedules));
  }
}

Future<UserAuth> getStoredAuth() async {
  final spInstance = await SharedPreferences.getInstance();
  if (spInstance.getString('idToken') == null) {
    return null;
  }
  return UserAuth(
    idToken: spInstance.getString('idToken'),
    refreshToken: spInstance.getString('refreshToken'),
    expirationTime: DateTime.fromMillisecondsSinceEpoch(
        spInstance.getInt('expirationTime')),
    uid: spInstance.getString('uid'),
  );
}

Future<bool> isFirstTimeUser() async {
  final spInstance = await SharedPreferences.getInstance();
  return spInstance.getBool('firstTime') == null;
}

Future<void> setFirstTimeStatus(bool status) async {
  final spInstance = await SharedPreferences.getInstance();
  await spInstance.setBool('firstTime', status);
}

Future<void> storeAuth(UserAuth auth) async {
  final spInstance = await SharedPreferences.getInstance();
  await spInstance.setString('idToken', auth.idToken);
  await spInstance.setString('refreshToken', auth.refreshToken);
  await spInstance.setInt(
      'expirationTime', auth.expirationTime.millisecondsSinceEpoch);
  await spInstance.setString('uid', auth.uid);
}
