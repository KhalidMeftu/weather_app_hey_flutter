import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/const/weather_paddings.dart';
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
    await Future.delayed(const Duration(seconds: 7));

    if (mounted) {
      Navigator.pushReplacementNamed(context, WeatherRoutes.homePageRoute,
          arguments: [false, null]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeatherAppColor.russianViolateColor,
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
                      color: WeatherAppColor.russianViolateColor)
                  .copyWith(fontSize: WeatherAppFontSize.s30),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, WeatherRoutes.homePageRoute,
                      arguments: [false, null]);
                },
                child: SizedBox(
                  width: 300.w,
                  child: Card(
                    elevation: 10,
                    color: WeatherAppColor.greyColor,
                    child: Padding(
                      padding: const EdgeInsets.all(WeatherAppPaddings.s8),
                      child: Center(
                        child: Text(
                          WeatherAppString.continueToPage,
                          style: WeatherAppFonts.large(
                                  fontWeight: FontWeight.w500,
                                  color: WeatherAppColor.blackColor)
                              .copyWith(fontSize: WeatherAppFontSize.s19),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

/// dont spin add screen shots and video thats all
/// ping medium

