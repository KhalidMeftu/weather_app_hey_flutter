import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import 'app_color.dart';

class AppUtils {

  /// a function to convert city name to lowercase to get city Image
  static String convertTextToLower(String cityName) {
    return cityName.toLowerCase();
  }

  /// on home page we have date format of Jun 07 so belows function takes todays date as an input and returns formated
/// output
  String getFormattedDate() {
    DateTime now = DateTime.now();
    ///  months
    List<String> monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    String month = monthNames[now.month];
    String year = now.year.toString();

    return '$month $year';
  }

  /// spinner to load data

  Widget loadingSpinner =  Center(
    child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(WeatherAppColor.redColor),
          strokeWidth: 3,
        )),
  );

  /// weather app response has this 02d for icons belows function will aligned with weather flutter

  IconData getWeatherIcon(String weatherCode) {
    switch (weatherCode) {
      case "01d":
        return WeatherIcons.day_sunny;
      case "02d":
        return WeatherIcons.day_cloudy;
      case "03d":
        return WeatherIcons.cloud;
      case "04d":
        return WeatherIcons.cloudy;
      case "09d":
        return WeatherIcons.showers;
      case "10d":
        return WeatherIcons.rain;
      case "11d":
        return WeatherIcons.thunderstorm;
    // Add more cases for other weather condition codes as needed
      default:
        return WeatherIcons.refresh; // A fallback icon in case of unknown code
    }
  }
}
