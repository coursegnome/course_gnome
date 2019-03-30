@TestOn('vm')
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:color/color.dart';
import 'package:core/core.dart';

void main() {
  test('Get all schedules', () async {
    http.Response x = await http.get(
      'https://firestore.googleapis.com/v1/projects/course-gnome/databases/(default)/documents/schools/gwu/users/dBPYxL3bHacEi6bD0IeIEQRpYtZ2',
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImZiMDEyZTk5Y2EwYWNhODI2ZTkwODZiMzIyM2JiOTYwZGFhOTFmODEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY291cnNlLWdub21lIiwiYXVkIjoiY291cnNlLWdub21lIiwiYXV0aF90aW1lIjoxNTUzODI3MjY0LCJ1c2VyX2lkIjoiZEJQWXhMM2JIYWNFaTZiRDBJZUlFUVJwWXRaMiIsInN1YiI6ImRCUFl4TDNiSGFjRWk2YkQwSWVJRVFScFl0WjIiLCJpYXQiOjE1NTM4MjcyNjQsImV4cCI6MTU1MzgzMDg2NCwiZW1haWwiOiJ0aW10cmF2ZXJzeUBnd3UuZWR1IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbInRpbXRyYXZlcnN5QGd3dS5lZHUiXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.V7hAdbiY4Cac8oCP7gnaH74weste3Dlr_gLb1GRoV1w1bqLzhlhD-EyEFmB0ahGRoaVDL4SsC5EPaKVGYeV36T1ztXcCtkfaZU1XcQItKIzcfI2CoSZnI5R72VfjqG0d1GOJBQWw2UrVEhlm-rXffCfNJGvHwp5e5RRyd6gLbSUjYzE8s0RBPp5UqxAQRsvgSb4che6PEYnZw7KUWmazjLZxMicviFUYc3y1YV13chTjA_pvTwu436wfejluud3uJD4F1MsHt7J1Hfn0TcQH4WqeUkg1N7Tn6B87noxt43jjbZCod5bwN394JFL9OSscBM2M6gvBtJi9ilrS9m5Zrw'
      },
    );
    print(x.body);
  });
}
