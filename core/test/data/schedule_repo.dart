@TestOn('vm')
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:color/color.dart';
import 'package:core/core.dart';

void main() {
  Future<void> _storeTokens(UserAuth tokens) async {}

  Future<UserAuth> _getTokens() async => UserAuth(
        idToken: '',
        refreshToken: '',
        expirationTime: DateTime.now(),
      );


  final ScheduleRepository scheduleRepository = ScheduleRepository(
    userRepository: userRepository,
  );

  test('Get all schedules', () async {
    await userRepository.getStoredTokens();
    await scheduleRepository.getAllSchedules();
  });
}
