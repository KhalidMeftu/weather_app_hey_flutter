import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class NewSplash extends StatefulWidget {
  const NewSplash({super.key});

  @override
  State<NewSplash> createState() => _NewSplashState();
}

class _NewSplashState extends State<NewSplash> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }


  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      Navigator.pushReplacementNamed(context, WeatherRoutes.homePageRoute,
          arguments: [false,null]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(WeatherAppResources.splashLottie),
          Center(
            child: Text(
              WeatherAppString.weatherCast,
              style: WeatherAppFonts.large(
                      fontWeight: FontWeight.w700,
                      color: WeatherAppColor.russianViolateColorColor)
                  .copyWith(fontSize: WeatherAppFontSize.s30),
            ),
          )
        ],
      ),
    );
  }
}

/// home implements shimmer effect untill data loads and splash will just show for 5sec
///
/// fix km/hr
/// %
/// user save bloc
