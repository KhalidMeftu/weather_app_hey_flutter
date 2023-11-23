import 'package:flutter/material.dart';

class WeatherAppColor {
  static Color transParentColor = Colors.transparent;
  static Color whiteColorWOpacity = const Color(0xffFFFFFF).withOpacity(0.25);
  static Color whiteColor = const Color(0xffFFFFFF);
  static Color colorForCard = const Color(0xffECECEC);
  static Color russianViolateColorColor= const Color(0xff391A49);
  static LinearGradient linearGradientBackground = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1121, 0.3242, 0.5592, 0.6939, 0.8957],
    colors: [
      Color(0xff391A49),
      Color(0xff301D5C),
      Color(0xff262171),
      Color(0xff301D5C),
      Color(0xff391A49),
    ],
    transform: GradientRotation(192.33),
  );
}
