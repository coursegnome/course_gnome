import 'package:flutter/material.dart';

import 'package:course_gnome_mobile/ui/SearchPage.dart';
import 'package:course_gnome_mobile/ui/LoginPage.dart';
import 'package:course_gnome_mobile/ui/SchedulingPage.dart';
import 'package:course_gnome_mobile/utilities/UtilitiesClasses.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: CGColor.cgred,
        fontFamily: 'Lato',
      ),
      home: SchedulingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
