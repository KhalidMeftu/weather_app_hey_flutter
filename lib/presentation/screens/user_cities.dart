import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_color.dart';

class UserCities extends StatelessWidget {
  const UserCities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Container(
        decoration: BoxDecoration(
          gradient: WeatherAppColor.linearGradientBackground,
        ),
        child: Center(
          child: Text("HI"),
        ),
      )
    );
  }
}
