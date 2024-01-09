import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';

class WeatherAppBar extends StatelessWidget {
  final String cityNames;

  const WeatherAppBar({
    super.key,
    required this.cityNames,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: WeatherAppColor.transParentColor,
      leading: Icon(Icons.location_on, color: WeatherAppColor.whiteColor),
      title: Text(
        cityNames,
        style: WeatherAppFonts.medium(
            fontWeight: FontWeight.w400, color: WeatherAppColor.whiteColor)
            .copyWith(fontSize: WeatherAppFontSize.s18),
      ),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, WeatherRoutes.savedCitiesRoute);
              },
              child: Icon(Icons.info_outline_sharp,
                  color: WeatherAppColor.whiteColor)),
        )
      ], // Removes shadow
    );
  }
}
