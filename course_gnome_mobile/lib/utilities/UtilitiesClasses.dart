import 'package:flutter/material.dart';

class TriColor {
  Color light, med, dark;
  TriColor(List<String> colors) {
    this.light = Color(int.parse('0xff${colors[0]}'));
    this.med = Color(int.parse('0xff${colors[1]}'));
    this.dark = Color(int.parse('0xff${colors[2]}'));
  }
}

class CGColor {
  static final cgred = Color(0xffD50110);
  static final lightGray = Color(0xffFAFAFA);
}
