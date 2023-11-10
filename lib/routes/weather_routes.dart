import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/presentation/screens/user_cities.dart';
import 'package:flutterweatherapp/presentation/screens/weather_home_page.dart';

class WeatherRoutes {
  static const String splashRoute = '/';
  static const String homePageRoute = '/home';
  static const String userCitiesRoute = '/userCities';
}

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {

     // case WeatherRoutes.splashRoute:
      //  return MaterialPageRoute(builder: (_) => const ());
        case WeatherRoutes.homePageRoute:
        return MaterialPageRoute(builder: (_) => const WeatherHomePage());
      case WeatherRoutes.userCitiesRoute:
        return MaterialPageRoute(builder: (_) => const UserCities());


      default:
        return unDefinedRoute();
    }
  }




  /// route is not found show error
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(WeatherAppString.weatherAppError),
          ),
          body:  Center(
            child: Text(WeatherAppString.weatherAppRouteNotFound),
          ),
        ));
  }
}
