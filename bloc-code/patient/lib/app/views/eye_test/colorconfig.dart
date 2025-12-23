import 'package:flutter/material.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

TextStyle style(
  double fontsize,
  String color,
) {
  return TextStyle(
      fontFamily: 'TT Commons', fontSize: fontsize, color: colorFromHex(color));
}

class ColorConfig {
  static const primaryColor = const Color(0xff00CFA5);
  static const mbasicFontColor = const Color(0xff766D6D);
  static const yeallow = const Color(0xffFEC539);
  static const black = const Color(0xff181D3D);
  // var yeallow = colorFromHex('#FEC539');
  //var black = colorFromHex('#181D3D');
}
