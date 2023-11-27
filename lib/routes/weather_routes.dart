import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/presentation/screens/splash_screen/splash_screen.dart';
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
      case WeatherRoutes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case WeatherRoutes.homePageRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => WeatherHomePage(
                  cityName: args[0],
                  imageUrl: args[1],
                  weatherModel: args[2],
                ));
      case WeatherRoutes.userCitiesRoute:
        return _createRoute( const UserCities());

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
              body: Center(
                child: Text(WeatherAppString.weatherAppRouteNotFound),
              ),
            ));
  }
  ///page transition animation]

  static Route<dynamic> _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0); // New page starts from the right
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
