import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/presentation/screens/home_page/home_page_widget.dart';
import 'package:flutterweatherapp/presentation/screens/saved_cities/saved_cities.dart';
import 'package:flutterweatherapp/presentation/screens/splash_page/splash_screen_widget.dart';

class WeatherRoutes {
  static const String homePageRoute = '/home';
  static const String splashRoute = '/newsplash';
  static const String savedCitiesRoute = '/userCities';

}

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {

      case WeatherRoutes.splashRoute:
        return MaterialPageRoute(builder: (_) => const NewSplash());

      case WeatherRoutes.homePageRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(builder: (_) => WeatherAppHomePage(showDataFromSavedCities: args[0],cityModel:args[1]));

      case WeatherRoutes.savedCitiesRoute:
        // back to right
        List<dynamic> args = routeSettings.arguments as List<dynamic>;

        return LeftToRightPageRoute( child:  CitiesList(isCurrentCityNotFound: args[0],),);

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
}

class LeftToRightPageRoute extends PageRouteBuilder {
  final Widget child;

  LeftToRightPageRoute({required this.child})
      : super(
    transitionDuration: const Duration(milliseconds: 500), // Shortened duration
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Use a fade transition for better performance and smoother look
    var begin = const Offset(-1.0, 0.0);
    var end = Offset.zero;
    var curve = Curves.easeOut; // Smoother curve for the transition

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: offsetAnimation,
        child: child,
      ),
    );
  }
}

