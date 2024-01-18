import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/const/app_extensions.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/common_widgets/weather_app_bar.dart';

class SavedCityWidget extends StatelessWidget {
  final List<String> upcomingDays;
  final WeatherModel cityModel;

  SavedCityWidget({super.key,
    required this.upcomingDays,
    required this.cityModel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        cityModel.cityImageURL!.isEmpty
            ? Positioned.fill(
          child: Image.asset(
            WeatherAppResources.cityPlaceHolder,
            fit: BoxFit.cover,
          ),
        )
            : Positioned.fill(
          child: FadeInImage(
            placeholder: AssetImage(WeatherAppResources.cityPlaceHolder),
            image: NetworkImage(cityModel.cityImageURL!),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: WeatherAppBar(
            cityNames: cityModel.name,
            onTap: () {
             AppUtils.goToSavedList(false, context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 70.h),
          child: ListView(
            children: [
              SizedBox(height: AppBar().preferredSize.height),
              30.0.sizeHeight,
              // Rest of the code...
            ],
          ),
        ),
      ],
    );
  }
}