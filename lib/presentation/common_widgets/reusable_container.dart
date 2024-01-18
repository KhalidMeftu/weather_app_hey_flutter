import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:weather_icons/weather_icons.dart';

class NextWeekCard extends StatelessWidget {
  final String daysOfWeek;
  final Daily forecastModel;

  const NextWeekCard({Key? key, required this.daysOfWeek, required this.forecastModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          daysOfWeek,
          style: WeatherAppFonts.large().copyWith(
              color: WeatherAppColor.whiteColor,
              fontWeight: FontWeight.w400).copyWith(fontSize: WeatherAppFontSize.s14),
        ),
        SizedBox(
          height: 10.h,
        ),
        AppUtils().getWeatherIcon(
          forecastModel.weather[0].icon)!=WeatherIcons.refresh?
        Icon(
          AppUtils().getWeatherIcon(
              forecastModel.weather[0].icon),
          size: 50.0,
          color: WeatherAppColor.yellowColor,


        ):Image.network(AppUtils().getWeatherIconURL( forecastModel.weather[0].icon),color: WeatherAppColor.yellowColor,),
        SizedBox(
          height: 10.h,
        ),
      /// temp
        Text(
          forecastModel.temp.day.toString(),
          style: WeatherAppFonts.large().copyWith(
              color: WeatherAppColor.whiteColor,
              fontWeight: FontWeight.w400).copyWith(fontSize: WeatherAppFontSize.s16),
        ),
        SizedBox(
          height: 10.h,
        ),

        // wind speed
        Text(
          forecastModel.windSpeed.toString(),
          style: WeatherAppFonts.large().copyWith(
              color: WeatherAppColor.whiteColor,
              fontWeight: FontWeight.w400).copyWith(fontSize: WeatherAppFontSize.s10),
        ),

        Text(
          "km/h",
          style: WeatherAppFonts.large().copyWith(
              color: WeatherAppColor.whiteColor,
              fontWeight: FontWeight.w400).copyWith(fontSize: WeatherAppFontSize.s10),
        ),

      ],
    );

  }
}
