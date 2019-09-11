import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'package:course_gnome/state/shared/config/config.dart';

const String refreshUrl = 'https://securetoken.googleapis.com/v1/';
const String auth =
    'https://www.googleapis.com/identitytoolkit/v3/relyingparty/';
const String firestore =
    'https://firestore.googleapis.com/v1/projects/course-gnome/databases/(default)/documents/';
const String authSuffix = '?key=$firebaseKey';
const int dbPrefixLength =
    'projects/course-gnome/databases/(default)/documents/'.length;

enum HttpError { BadRequest, NetworkError }

Future<Map<String, dynamic>> authPost({
  @required String endpoint,
  String idToken,
  Map<String, dynamic> body,
}) async {
  if (idToken != null) {
    body = body ?? <String, dynamic>{};
    body['idToken'] = idToken;
  }
  try {
    final Response response = await post(
      (endpoint == 'token' ? refreshUrl : auth) + endpoint + authSuffix,
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      print(response.reasonPhrase);
      throw HttpError.BadRequest;
    }
    return jsonDecode(response.body);
  } catch (e) {
    print('Http Error: ${e.toString()}');
    throw HttpError.NetworkError;
  }
}

Future<String> createDoc({
  @required String idToken,
  @required String path,
  @required Map<String, dynamic> fields,
}) async {
  try {
    final Response response = await post(
      firestore + path,
      body: _parseDocumentMap(fields),
      headers: _buildAuthHeaders(idToken),
    );
    if (response.statusCode != 200) {
      print('Http Error: ${response.reasonPhrase}');
      throw HttpError.BadRequest;
    }
    final String name = jsonDecode(response.body)['name'];
    return name.substring(dbPrefixLength + path.length + 1);
  } catch (e) {
    print('Http Error: ${e.toString()}');
    throw HttpError.NetworkError;
  }
}

Future<Map<String, dynamic>> patchDoc({
  @required String idToken,
  @required String path,
  @required Map<String, dynamic> fields,
  List<String> updateMask,
}) async {
  try {
    final Response response = await patch(
      firestore + path + fieldMask(updateMask),
      body: _parseDocumentMap(fields),
      headers: _buildAuthHeaders(idToken),
    );
    if (response.statusCode != 200) {
      print('Http Error: ${response.reasonPhrase}');
      throw HttpError.BadRequest;
    }
    return _parseFields(jsonDecode(response.body));
  } catch (e) {
    print('Http Error: ${e.toString()}');
    throw HttpError.NetworkError;
  }
}

String fieldMask(List<String> fields) {
  if (fields == null || fields.isEmpty) {
    return '';
  }
  return '?updateMask.fieldPaths=' +
      fields.reduce((x, y) => x + '&updateMask.fieldPaths=' + y);
}

Map<String, String> _buildAuthHeaders(String idToken) {
  return {'authorization': 'Bearer $idToken'};
}

Future<Map<String, dynamic>> getRequest({String idToken, String path}) async {
  try {
    final Response response = await get(
      firestore + path,
      headers: _buildAuthHeaders(idToken),
    );
    if (response.statusCode != 200) {
      print('Http Error: ${response.reasonPhrase}');
      throw HttpError.BadRequest;
    }
    return jsonDecode(response.body);
  } catch (e) {
    print('Http Error: ${e.toString()}');
    throw HttpError.NetworkError;
  }
}

Future<Map<String, dynamic>> getDoc({
  @required String path,
  @required String idToken,
}) async {
  return _parseFields(await getRequest(idToken: idToken, path: path));
}

Future<List<Map<String, dynamic>>> getDocs({
  @required String path,
  @required String idToken,
}) async {
  final Map response = await getRequest(idToken: idToken, path: path);
  final List<Map> documents = response['documents'];
  if (response.isEmpty) {
    return null;
  }
  for (Map document in documents) {
    document = _parseFields(document);
  }
  return documents;
}

Future<void> deleteDoc({@required String path}) async {
  try {
    final Response response = await delete(
      firestore + path,
    );
    if (response.statusCode != 200) {
      print('Http Error: ${response.reasonPhrase}');
      throw HttpError.BadRequest;
    }
  } catch (e) {
    print('Http Error: ${e.toString()}');
    throw HttpError.NetworkError;
  }
}

Map<String, dynamic> _parseFields(Map document) {
  final map = <String, dynamic>{};
  for (final entry in document['fields'].entries) {
    final Map<String, dynamic> entryMap = entry.value;
    switch (entryMap.entries.first.key) {
      case 'integerValue':
        map[entry.key] = int.parse(entryMap.entries.first.value);
        break;
      case 'doubleValue':
        map[entry.key] = double.parse(entryMap.entries.first.value);
        break;
      case 'nullValue':
        map[entry.key] = null;
        break;
      default:
        map[entry.key] = entryMap.entries.first.value;
    }
  }
  return map;
}

String _parseDocumentMap(Map<String, dynamic> document) {
  return json.encode(_recursiveParse(document));
}

Map<String, dynamic> _recursiveParse(Map<String, dynamic> document) {
  final fields = <String, dynamic>{};
  for (final entry in document.entries) {
    fields[entry.key] = _valueToFBFormat(entry.value);
  }
  return <String, dynamic>{'fields': fields};
}

Map<String, dynamic> _valueToFBFormat(dynamic value) {
  if (value == null) {
    return <String, dynamic>{'nullValue': value};
  }
  if (value is bool) {
    return <String, dynamic>{'booleanValue': value};
  }
  if (value is int) {
    return <String, dynamic>{'integerValue': value};
  }
  if (value is double) {
    return <String, dynamic>{'doubleValue': value};
  }
  if (value is DateTime) {
    return <String, dynamic>{'timestampValue': value.toUtc().toIso8601String()};
  }
  if (value is String) {
    return <String, dynamic>{'stringValue': value};
  }
  if (value is List) {
    final arrayValue = {
      'arrayValue': {'values': <dynamic>[]}
    };
    for (final subVal in value) {
      if (subVal is List) {
        throw const FormatException(
            'Error: an array cannot directly contain another array value');
      }
      arrayValue['arrayValue']['values'].add(_valueToFBFormat(subVal));
    }
    return arrayValue;
  }
  if (value is Map) {
    return <String, dynamic>{'mapValue': _recursiveParse(value)};
  }
  throw ArgumentError('The argument $value is not supported by Firebase');
}
