import 'package:meta/meta.dart';

import 'package:course_gnome/state/auth/auth.dart';
import 'package:course_gnome/state/shared/utilites/firebase_io.dart';

enum UserError { NotAuthenticated }

class UserAuth {
  UserAuth({
    @required this.idToken,
    @required this.refreshToken,
    @required this.expirationTime,
    @required this.uid,
  })  : assert(idToken != null),
        assert(refreshToken != null),
        assert(expirationTime != null),
        assert(uid != null);
  final String idToken, refreshToken, uid;
  final DateTime expirationTime;
}

class UserRepository {
  static String tag = 'UserRepository';

  Future<void> init() async {
    print('$tag - init');
    _userAuth = await getStoredAuth();
  }

  UserAuth _userAuth;

  String get uid => _userAuth.uid;

  Future<String> get idToken async {
    print('$tag - get idToken');
    if (!isAuthenticated) {
      throw UserError.NotAuthenticated;
    }
    await _refreshTokenIfNeeded();
    print('$tag - getToken - got idToken: ${_userAuth.idToken}');
    return _userAuth.idToken;
  }

  bool get isAuthenticated => _userAuth != null;

  void setNewAuth(Map response) {
    print('$tag - setNewAuth -  with response: $response');
    DateTime dateFromStringSec(String sec) =>
        DateTime.now().add(Duration(seconds: int.parse(sec)));
    _userAuth = UserAuth(
      uid: response['user_id'] ?? response['localId'],
      refreshToken: response['refresh_token'] ?? response['refreshToken'],
      idToken: response['id_token'] ?? response['idToken'],
      expirationTime:
          dateFromStringSec(response['expires_in'] ?? response['expiresIn']),
    );
    print('$tag - setNewAuth - storeAuth: $_userAuth');
    storeAuth(_userAuth);
  }

  Future<void> _refreshTokenIfNeeded() async {
    print('$tag - refreshToken');
    if (DateTime.now().isBefore(_userAuth.expirationTime)) {
      print('$tag - refreshToken - refresh not needed');
      return;
    }
    print('$tag - refreshToken - refreshing');
    final Map response = await authPost(
      endpoint: 'token',
      body: <String, dynamic>{
        'grant_type': 'refresh_token',
        'refresh_token': _userAuth.refreshToken,
      },
    );
    print('$tag - refreshToken - setting new auth');
    setNewAuth(response);
  }

  void signOut() {
    print('$tag - signOut');
    _userAuth = null;
    storeAuth(null);
  }
}
