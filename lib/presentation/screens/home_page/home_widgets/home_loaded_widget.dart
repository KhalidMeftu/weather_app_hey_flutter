import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_extensions.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/common_widgets/reusable_container.dart';
import 'package:flutterweatherapp/presentation/common_widgets/weather_app_bar.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast_controller/get_daily_forecast_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:weather_icons/weather_icons.dart';

import 'home_utils.dart';

class CurrentCityLoadedUIWidget extends StatelessWidget {
  final WeatherModel weatherCityModel;
  final List<String> upcomingDays;

  const CurrentCityLoadedUIWidget({
    super.key,
    required this.weatherCityModel,
    required this.upcomingDays,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        weatherCityModel.cityImageURL!.isEmpty
            ? Positioned.fill(
                child: Image.asset(
                  WeatherAppResources.cityPlaceHolder,
                  fit: BoxFit.cover,
                ),
              )
            : Positioned.fill(
                child: FadeInImage(
                  placeholder: AssetImage(WeatherAppResources.cityPlaceHolder),
                  image: NetworkImage(weatherCityModel.cityImageURL!),
                  fit: BoxFit.cover,
                ),
              ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: WeatherAppBar(
            cityNames: weatherCityModel.name,
            onTap: () {
              HomeUtils.goToSavedList(false, context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 70.h),
          child: ListView(
            children: [
              SizedBox(height: AppBar().preferredSize.height),
              20.0.sizeHeight,

              /// today
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GlassContainer(
                  color: WeatherAppColor.blackColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      Center(
                          child: Text(AppUtils.getFormattedDate(),
                              style: WeatherAppFonts.large(
                                      fontWeight: FontWeight.w300,
                                      color: WeatherAppColor.whiteColor)
                                  .copyWith(fontSize: WeatherAppFontSize.s30))),
                      2.0.sizeHeight,

                      /// updated at
                      2.0.sizeHeight,
                      Center(
                          child: Text(
                              AppUtils.formatDateTime(
                                  weatherCityModel.updatedAt.toIso8601String()),
                              style: WeatherAppFonts.large(
                                      fontWeight: FontWeight.w300,
                                      color: WeatherAppColor.whiteColor
                                          .withOpacity(0.75))
                                  .copyWith(fontSize: WeatherAppFontSize.s16))),

                      /// display data from API
                      Column(
                        children: [
                          10.0.sizeHeight,

                          AppUtils().getWeatherIcon(
                                      weatherCityModel.weather[0].icon) !=
                                  WeatherIcons.refresh
                              ? Icon(
                                  AppUtils().getWeatherIcon(
                                      weatherCityModel.weather[0].icon),
                                  size: 100.0,
                                  color: WeatherAppColor.yellowColor,
                                )
                              : Image.network(
                                  AppUtils().getWeatherIconURL(
                                      weatherCityModel.weather[0].icon),
                                  color: WeatherAppColor.yellowColor,
                                ),
                          10.0.sizeHeight,

                          Text(
                            weatherCityModel.weather[0].description
                                .capitalizeFirstLater(),
                            style: WeatherAppFonts.large(
                                    fontWeight: FontWeight.w700,
                                    color: WeatherAppColor.whiteColor)
                                .copyWith(fontSize: WeatherAppFontSize.s30),
                          ),

                          //temp
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          weatherCityModel.main.temp.toString(),
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s48),
                                    ),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: const Offset(2, -8),
                                        child: Text(
                                          WeatherAppString.degreeCelsius,
                                          // The superscript part
                                          // Smaller font size for the superscript
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w700,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                            fontSize: WeatherAppFontSize.s24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          ///
                          /// humidty... feels like
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Column(
                                  children: [
                                    Image(
                                      image:
                                          Svg(WeatherAppResources.humidtyIcon),
                                    ),
                                    3.0.sizeHeight,
                                    Text(
                                      AppUtils.convertTextToUpper(
                                          WeatherAppString.humidityText),
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s14),
                                    ),
                                    3.0.sizeHeight,
                                    Text(
                                      "${weatherCityModel.main.humidity} ${WeatherAppString.percentageText}",
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image(
                                      image: Svg(WeatherAppResources.windIcon),
                                    ),
                                    3.0.sizeHeight,
                                    Text(
                                      AppUtils.convertTextToUpper(
                                          WeatherAppString.windText),
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s14),
                                    ),
                                    3.0.sizeHeight,
                                    Text(
                                      "${weatherCityModel.wind.speed} ${WeatherAppString.kmPerHour}",
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image(
                                      image: Svg(WeatherAppResources.feelsLike),
                                    ),
                                    3.0.sizeHeight,
                                    Text(
                                      AppUtils.convertTextToUpper(
                                          WeatherAppString.feelsLikeText),
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s14),
                                    ),
                                    3.0.sizeHeight,
                                    Text(
                                      weatherCityModel.main.feelsLike
                                          .toString(),
                                      style: WeatherAppFonts.large(
                                              fontWeight: FontWeight.w500,
                                              color: WeatherAppColor.whiteColor)
                                          .copyWith(
                                              fontSize: WeatherAppFontSize.s14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              BlocBuilder<GetDailyForecastBloc, GetDailyForecastState>(
                  builder: (context, states) {
                if (states is LoadingDailyForecast) {}
                if (states is DailyForecastLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: SizedBox(
                        height: 200.h,
                        child: GlassContainer(
                          color: WeatherAppColor.blackColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // Center items in the Row
                                children: List.generate(
                                    states.forecastList.length, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 7.w, right: 7.w, top: 20.h),
                                    child: NextWeekCard(
                                      daysOfWeek: upcomingDays[index],
                                      forecastModel: states.forecastList[index],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Container();
              })
            ],
          ),
        ),
      ],
    );
  }
}
