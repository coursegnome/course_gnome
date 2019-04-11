import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/core.dart';

Future<void> storeAuth(UserAuth auth) async {
  final spInstance = await SharedPreferences.getInstance();
  await spInstance.setString('idToken', auth.idToken);
  await spInstance.setString('refreshToken', auth.refreshToken);
  await spInstance.setInt(
      'expirationTime', auth.expirationTime.millisecondsSinceEpoch);
  await spInstance.setString('uid', auth.uid);
}

Future<UserAuth> getStoredAuth() async {
  final spInstance = await SharedPreferences.getInstance();
  return UserAuth(
    idToken: await spInstance.getString('idToken'),
    refreshToken: await spInstance.getString('refreshToken'),
    expirationTime: DateTime.fromMillisecondsSinceEpoch(
        await spInstance.getInt('expirationTime')),
    uid: await spInstance.getString('uid'),
  );
}

Future<bool> isFirstTimeUser() async {
  final spInstance = await SharedPreferences.getInstance();
  return await spInstance.getBool('firstTime') == null;
}

Future<void> setFirstTimeStatus(bool status) async {
  final spInstance = await SharedPreferences.getInstance();
  await spInstance.setBool('firstTime', status);
}
