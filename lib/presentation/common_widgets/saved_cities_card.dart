import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:weather_icons/weather_icons.dart';

class SavedCitiesCard extends StatelessWidget {
  final String cityName;
  final String weatherCondition;
  final String humidity;
  final String windSpeed;
  final String statusImage;
  final String temprature;
  final bool isHomeCity;

  const SavedCitiesCard(
      {Key? key,
      required this.cityName,
      required this.weatherCondition,
      required this.humidity,
      required this.windSpeed,
      required this.statusImage,
      required this.temprature,
        required this.isHomeCity,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:BoxDecoration(
          color: WeatherAppColor.cardB,
          borderRadius: const BorderRadius.all(Radius.circular(16))
        ),
        child: Column(
          children: [

            
            Row(
              children: [
                /// display city name weather condition and humidity and wind
                /// home icon

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          cityName,
                          style: WeatherAppFonts.large().copyWith(
                              color: WeatherAppColor.whiteColor,
                              fontSize: WeatherAppFontSize.s22,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          weatherCondition,
                          style: WeatherAppFonts.medium().copyWith(
                              color: WeatherAppColor.whiteColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              fontSize: WeatherAppFontSize.s16),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Text(
                              "${WeatherAppString.humidityText}: ",
                              style: WeatherAppFonts.medium().copyWith(
                                  color: WeatherAppColor.whiteColor.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                  fontSize: WeatherAppFontSize.s16),
                            ),
                            Text(
                              humidity,
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
                              "${WeatherAppString.windText}:",
                              style: WeatherAppFonts.medium().copyWith(
                                  color: WeatherAppColor.whiteColor.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                  fontSize: WeatherAppFontSize.s16),
                            ),
                            Text(
                              windSpeed,
                              style: WeatherAppFonts.medium().copyWith(
                                  color: WeatherAppColor.whiteColor.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  fontSize: WeatherAppFontSize.s16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 8.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //// image
                      AppUtils().getWeatherIcon(statusImage) != WeatherIcons.refresh
                          ? Icon(
                              AppUtils().getWeatherIcon(statusImage),
                              size: 50.0,
                               color: WeatherAppColor.yellowColor,
                            )
                          : Image.network(
                              AppUtils().getWeatherIconURL(statusImage),color: WeatherAppColor.yellowColor,),

                      SizedBox(
                        height: 14.h,
                      ),
                      Row(
                        children: [
                          Text(
                            temprature,
                            style: WeatherAppFonts.medium().copyWith(
                                color: WeatherAppColor.whiteColor.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: WeatherAppFontSize.s30),
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
                ),

              ],
            ),
          ],
        ));
  }
}
