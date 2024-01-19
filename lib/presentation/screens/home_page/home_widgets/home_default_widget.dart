import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_paddings.dart';

class DefaultUIWidget extends StatelessWidget {
  final bool isLocationServiceInitialized;
  const DefaultUIWidget({super.key, required this.isLocationServiceInitialized});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              WeatherAppResources.cityPlaceHolder,
              fit: BoxFit.cover,
            ),
          ),
         Align(
            alignment: Alignment.center,
            child: AppUtils().loadingSpinner,
          ),
          isLocationServiceInitialized? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(WeatherAppPaddings.s30),
              child: Text(
                WeatherAppString.loading,
                style: TextStyle(color: WeatherAppColor.redColor),
              ),
            ),
          ):Container(),
        ],
      ),
    );
  }
}