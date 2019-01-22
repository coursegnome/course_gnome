import 'package:flutter/material.dart';

import 'package:course_gnome/ui/SearchPage.dart';
import 'ui/LoginPage.dart';
import 'ui/SchedulingPage.dart';
import 'utilities/Utilities.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: CGColors.cgred,
        fontFamily: 'Lato',
      ),
      home: SchedulingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
