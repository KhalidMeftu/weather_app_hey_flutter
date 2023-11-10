import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';


class WeatherAppFonts {
  static const String roboto = 'Roboto';
  static TextStyle _baseFont({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    required double fontSize,
  }) {
    return TextStyle(
      fontFamily: roboto,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static TextStyle extraSmall({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return _baseFont(
      color: color,
      fontWeight: fontWeight,
      fontSize: WeatherAppFontSize.s10,
    );
  }

  static TextStyle small({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return _baseFont(
      color: color,
      fontWeight: fontWeight,
      fontSize:WeatherAppFontSize.s12,
    );
  }

  static TextStyle medium({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return _baseFont(
      color: color,
      fontWeight: fontWeight,
      fontSize: WeatherAppFontSize.s16,
    );
  }

  static TextStyle large({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return _baseFont(
      color: color,
      fontWeight: fontWeight,
      fontSize: WeatherAppFontSize.s24,
    );
  }



}