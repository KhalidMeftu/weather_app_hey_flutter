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
        return LeftToRightPageRoute( child:  const CitiesList(),);

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

class LeftToRightPageRoute extends PageRouteBuilder {
  final Widget child;

  LeftToRightPageRoute({required this.child})
      : super(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1,0),
              end: Offset.zero

            ).animate(animation),
            child: child,
    );
  }
}
