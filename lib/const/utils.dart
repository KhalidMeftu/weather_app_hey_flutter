import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/services.dart';
import 'package:weather_icons/weather_icons.dart';
import 'app_color.dart';

class AppUtils {

  /// a function to convert city name to lowercase to get city Image
  static String convertTextToLower(String cityName) {
    return cityName.toLowerCase();
  }

  /// to upper case
  /// a function to convert city name to lowercase to get city Image
  static String convertTextToUpper(String text) {
    return text.toUpperCase();
  }


  /// only first later to upper case for api response of current city
  static String convertFirstTextToUpper(String text) {
    return text[0].toUpperCase()+text.substring(1);
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
      case "13d":
        return WeatherIcons.snow;
        default:
        return WeatherIcons.refresh; // A fallback icon in case of unknown code
    }
  }
  /// some datas are missing from WEATHER ICONS SO WE MANUALLY HIT THE url

  String getWeatherIconURL(String weatherCode) {

        return WeatherAppServices.iconURL+weatherCode+WeatherAppServices.iconSize;



  }

  /// get next four days

  static List<String> getNextFourDays() {
    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    DateTime currentDate = DateTime.now();
    int todayIndex = currentDate.weekday % 7;

    List<String> nextDays = [];
    for (int i = 1; i <= 4; i++) {
      DateTime nextDate = currentDate.add(Duration(days: i));
      String day = daysOfWeek[nextDate.weekday % 7];
      String dayWithNumber = '$day ${nextDate.day}';
      nextDays.add(dayWithNumber);
    }

    return nextDays;
  }




}
