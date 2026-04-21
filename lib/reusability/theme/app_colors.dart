import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class AppColors {
  static Color appPrimaryColor = '#1F41BB'.toColor();
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color red = Colors.red;
  static Color black200 = '#3A403E'.toColor();
  static Color black100 = '#E4DAD2'.toColor();
  static Color white100 = '#F8FAFF'.toColor();
  static Color lightGrey = '#F7F7F7'.toColor();
  static Color grey = '#EAEAEA'.toColor();
  static Color green = '#41B75F'.toColor();
  static Color textGrey = '#898989'.toColor();
  static Color lightBlue = '#A3F0F0'.toColor();
  static Color blue = '#45A9DF'.toColor();
}