import 'package:flutter/material.dart';
import 'package:course_gnome/model/UtilityClasses.dart';

class CGColor {
  static final cgred = Color(0xffD50110);
  static final lightGray = Color(0xffFAFAFA);
}

class FlutterTriColor {
  static Color toFlutter(String color) => Color(int.parse('0xff$color'));
  Color light, med, dark;
  FlutterTriColor(TriColor color) {
//    print(color.light);
//    print(toFlutter(color.light));
    this.light = toFlutter(color.light);
    this.med = toFlutter(color.med);
    this.dark = toFlutter(color.dark);
  }
  TriColor toTriColor() {
    return TriColor(
      light.toString().substring(10, light.toString().length - 1),
      med.toString().substring(10, med.toString().length - 1),
      dark.toString().substring(10, dark.toString().length - 1),
    );
  }
}
