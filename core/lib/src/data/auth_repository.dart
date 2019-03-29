import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:core/core.dart';
import 'config.dart';

class Tokens {
  Tokens({this.token, this.refreshToken, this.expirationTime});
  final String token, refreshToken;
  final DateTime expirationTime;
}

typedef GetStoredTokens = Future<Tokens> Function();
typedef StoreTokens = Future<void> Function(Tokens);

class AuthRepository {
  AuthRepository({
    @required this.getStoredTokens,
    @required this.storeTokens,
    @required this.school,
  });
  final GetStoredTokens getStoredTokens;
  final StoreTokens storeTokens;
  final School school;

  Tokens tokens;

  static const String baseUrl =
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/';
  static const String prefix = '?key=$firebaseKey';

  Future<User> init() async {
    tokens = await getStoredTokens();
    if (tokens == null) {
      // new user
      return await _signInAnonymously();
    }
    // old user (anon or not)
    await _refreshTokenIfNeeded();
    return await _getUserData();
  }

  Future<User> _signInAnonymously() async {
    final Map response = await _post(
      'signupNewUser',
      {'returnSecureToken': true},
    );
    tokens = Tokens(
      refreshToken: response['refreshToken'],
      token: response['idToken'],
      expirationTime: DateTime.now().add(Duration(minutes: 50)),
    );
    storeTokens(tokens);
    return User(id: response['localId']);
  }

  Future<User> signIn({
    String username,
    String password,
  }) async {
    try {
      final Map response = await _post('verifyPassword', {
        'returnSecureToken': true,
        'email': '$username@${school.domain}',
        'password': password,
      });
      tokens = Tokens(
        refreshToken: response['refreshToken'],
        token: response['idToken'],
        expirationTime: DateTime.now().add(Duration(minutes: 50)),
      );
      storeTokens(tokens);
      return _getUserData();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> signUp({
    @required String username,
    @required String password,
  }) async {
    final bool anonUser = tokens != null;
    final String endPoint = anonUser ? 'setAccountInfo' : 'signupNewUser';
    final Map requestBody = {
      'returnSecureToken': true,
      'email': '$username@${school.domain}',
      'password': password,
    };
    if (anonUser) {
      requestBody['idToken'] = tokens.token;
    }
    try {
      final Map response = await _post(
        endPoint,
        requestBody,
      );
      tokens = Tokens(
        refreshToken: response['refreshToken'],
        token: response['idToken'],
        expirationTime: DateTime.now().add(Duration(minutes: 50)),
      );
      storeTokens(tokens);
      //_sendVerificationEmail();
      return _getUserData();
    } catch (e) {
      rethrow;
    }
  }

  _sendVerificationEmail() async {
    Map e = await _post('getOobConfirmationCode', {
      'requestType': 'VERIFY_EMAIL',
      'idToken': tokens.token,
    });
    print(e);
  }

  Future<void> _refreshTokenIfNeeded() async {
    if (DateTime.now().isBefore(tokens.expirationTime)) {
      return;
    }
    final Map response = await _post(
      'token',
      {
        'grant_type': 'refresh_token',
        'refresh_token': tokens.refreshToken,
      },
    );
    tokens = Tokens(
      refreshToken: response['refresh_token'],
      token: response['id_token'],
      expirationTime: DateTime.now().add(Duration(minutes: 50)),
    );
    storeTokens(tokens);
  }

  Future<User> _getUserData() async {
    final Map response = await _post('getAccountInfo', {
      'idToken': tokens.token,
    });
    final List users = response['users'];
    return User.fromJson(users.first);
  }

  Future<void> deleteUser() async {
    try {
      await _post('deleteAccount', {'idToken': tokens.token});
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _post(String endPoint, Map body) async {
    final http.Response response = await http.post(
      baseUrl + endPoint + prefix,
      body: jsonEncode(body),
    );
    if (response.statusCode == 400) {
      throw response.reasonPhrase;
    }
    return jsonDecode(response.body);
  }
}
