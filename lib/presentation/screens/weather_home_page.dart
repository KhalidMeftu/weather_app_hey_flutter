import 'package:flutter/material.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';

class WeatherHomePage extends StatelessWidget {
  final String cityName;
  final String imageUrl;

  const WeatherHomePage(
      {Key? key, required this.cityName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// some city's image not found example addis ababa so if we have null image we will display default city image
          imageUrl.isEmpty
              ? Positioned.fill(
                  child: Image.asset(
                    WeatherAppResources.cityPlaceHolder,
                    fit: BoxFit.cover,
                  ),
                )
              : Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WeatherAppBar(cityName: cityName),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: AppBar().preferredSize.height),
                const Text("Test title"),
                Text(cityName),
                Text((imageUrl.isEmpty).toString()),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherAppBar extends StatelessWidget {
  const WeatherAppBar({
    super.key,
    required this.cityName,
  });

  final String cityName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: WeatherAppColor.transParentColor,
      leading: Icon(Icons.location_on, color: WeatherAppColor.whiteColor),
      title: Text(
        cityName,
        style: WeatherAppFonts.medium(
                fontWeight: FontWeight.w400, color: WeatherAppColor.whiteColor)
            .copyWith(fontSize: WeatherAppFontSize.s18),
      ),
      elevation: 0,
      actions: [
        Icon(Icons.more_vert_sharp, color: WeatherAppColor.whiteColor)
      ], // Removes shadow
    );
  }
}
