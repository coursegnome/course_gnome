import 'package:meta/meta.dart';
import 'http_wrapper.dart';

enum UserError { NotAuthenticated }

class UserAuth {
  UserAuth({this.idToken, this.refreshToken, this.expirationTime, this.uid});
  final String idToken, refreshToken, uid;
  final DateTime expirationTime;
}

typedef GetStoredTokens = Future<UserAuth> Function();
typedef StoreTokens = Future<void> Function(UserAuth);

class UserRepository {
  UserRepository({
    @required this.getStoredTokensCallback,
    @required this.storeTokensCallback,
  });

  final GetStoredTokens getStoredTokensCallback;
  final StoreTokens storeTokensCallback;

  Future<void> init() async {
    _userAuth = await getStoredTokensCallback();
  }

  UserAuth _userAuth;

  String get uid => _userAuth.uid;

  Future<String> get idToken async {
    if (!isAuthenticated) {
      throw UserError.NotAuthenticated;
    }
    await _refreshTokenIfNeeded();
    return _userAuth.idToken;
  }

  bool get isAuthenticated => _userAuth != null;

  void setNewAuth(Map response) {
    _userAuth = UserAuth(
      uid: response['user_id'] ?? response['localId'],
      refreshToken: response['refresh_token'] ?? response['refreshToken'],
      idToken: response['id_token'] ?? response['idToken'],
      expirationTime: DateTime.now().add(Duration(minutes: 50)),
    );
    storeTokensCallback(_userAuth);
  }

  Future<void> _refreshTokenIfNeeded() async {
    if (DateTime.now().isBefore(_userAuth.expirationTime)) {
      return;
    }
    final Map response = await authPost(
      endpoint: 'token',
      body: <String, dynamic>{
        'grant_type': 'refresh_token',
        'refresh_token': _userAuth.refreshToken,
      },
    );
    setNewAuth(response);
  }

  void signOut() {
    _userAuth = null;
    storeTokensCallback(null);
  }
}
