import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_app_radius.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextWeekCard extends StatelessWidget {
  final List<String> daysOfWeek;
  final List<String> daysWeather;
  final List<String> temprature;
  final List<String> windSpeed;

  const NextWeekCard({Key? key, required this.daysOfWeek, required this.daysWeather, required this.temprature, required this.windSpeed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: WeatherAppColor.transParentColor,
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(WeatherAppRadius.w24))),

        /// todo padding
        child: Row(
          children: [
            /// display city name weather condition and humidty and wind
            Column(
              children: [
                Text(
                  "cityName",
                  style: WeatherAppFonts.large().copyWith(
                      color: WeatherAppColor.whiteColor,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "weatherCondition",
                  style: WeatherAppFonts.medium().copyWith(
                      color: WeatherAppColor.whiteColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: WeatherAppFontSize.s16),
                ),
                Row(
                  children: [
                    Text(
                      WeatherAppString.humidityText,
                      style: WeatherAppFonts.medium().copyWith(
                          color: WeatherAppColor.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                          fontSize: WeatherAppFontSize.s16),
                    ),
                    Text(
                      "humidity",
                      style: WeatherAppFonts.medium().copyWith(
                          color: WeatherAppColor.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontSize: WeatherAppFontSize.s16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      WeatherAppString.windText,
                      style: WeatherAppFonts.medium().copyWith(
                          color: WeatherAppColor.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                          fontSize: WeatherAppFontSize.s16),
                    ),
                    Text(
                      "windSpeed",
                      style: WeatherAppFonts.medium().copyWith(
                          color: WeatherAppColor.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontSize: WeatherAppFontSize.s16),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                //// image
                SvgPicture.asset(
                  "statusImage",
                ),
                Row(
                  children: [
                    Text(
                      "temprature",
                      style: WeatherAppFonts.medium().copyWith(
                          color: WeatherAppColor.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: WeatherAppFontSize.s48),
                    ),
                    Text(
                      WeatherAppString.degreeCelsius,
                      style: WeatherAppFonts.medium().copyWith(
                          color: WeatherAppColor.whiteColor.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontFeatures: [
                            const FontFeature.enable('sups'),
                          ],
                          fontSize: WeatherAppFontSize.s16),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));

  }
}
