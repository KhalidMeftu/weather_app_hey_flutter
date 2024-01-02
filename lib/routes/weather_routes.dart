import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutterweatherapp/presentation/screens/cities_list/user_cities.dart';
import 'package:flutterweatherapp/presentation/screens/home/weather_home_page.dart';

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
        //return MaterialPageRoute(builder: (_) => const SplashScreen());
        return routingTransition(const SplashScreen());

      case WeatherRoutes.homePageRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        //return MaterialPageRoute(
        //   builder: (_) => HomePage(model: args[0]));
        return routingTransition(HomePage(model: args[0]));
      case WeatherRoutes.userCitiesRoute:
        return routingTransition(const CitiesList());

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

  static Route<dynamic> routingTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
        var offsetAnimation = animation.drive(tween);
        var delayedAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(
                curve: const Interval(0.2, 1.0,
                    curve: Curves.ease)), // Adjust the delay timing here
          ),
        );

        return AnimatedBuilder(
          animation: delayedAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: offsetAnimation,
              child: Opacity(
                opacity: delayedAnimation.value,
                // Apply the delay effect to the opacity
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
