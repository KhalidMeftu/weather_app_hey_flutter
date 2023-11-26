import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/common_widgets/reusable_container.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:weather_icons/weather_icons.dart';

import '../controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';

class WeatherHomePage extends StatelessWidget {
  final String cityName;
  final String imageUrl;

  const WeatherHomePage(
      {Key? key, required this.cityName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myBloc = BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
    myBloc.add(GetUserCityWeather(cityName));
    List<String> upcomingDays = AppUtils.getNextFourDays();
   // List<Daily> dailyForecasts = forecastModel.daily;



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
            child: ListView(
              children: [
                SizedBox(height: AppBar().preferredSize.height),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                    child: Text(AppUtils().getFormattedDate(),
                        style: WeatherAppFonts.large(
                                fontWeight: FontWeight.w500,
                                color: WeatherAppColor.whiteColor)
                            .copyWith(fontSize: WeatherAppFontSize.s40))),
                SizedBox(
                  height: 2.h,
                ),

                /// time stamp
                Center(
                    child: Text(AppUtils().getFormattedDate(),
                        style: WeatherAppFonts.large(
                                fontWeight: FontWeight.w300,
                                color: WeatherAppColor.whiteColor
                                    .withOpacity(0.75))
                            .copyWith(fontSize: WeatherAppFontSize.s16))),

                /// display data from API
                BlocBuilder<GetUserCityWeatherControllerBloc,
                    GetUserCityWeatherControllerState>(
                  builder: (context, state) {
                    if (state is UserCityWeatherLoading) {
                      return AppUtils().loadingSpinner;
                    }
                    if (state is UserCityWeatherLoaded) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          AppUtils().getWeatherIcon(
                              state.cityWeatherInformation.weather[0].icon)!=WeatherIcons.refresh? Icon(
                            AppUtils().getWeatherIcon(
                                state.cityWeatherInformation.weather[0].icon),
                            size: 100.0,
                          ):Image.network(AppUtils().getWeatherIconURL(state.cityWeatherInformation.weather[0].icon)),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(state
                              .cityWeatherInformation.weather[0].description, style: WeatherAppFonts.large(fontWeight: FontWeight.w700, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s30),),

                          //temp
                          Row(
                            crossAxisAlignment:CrossAxisAlignment.center,
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Text(state
                                  .cityWeatherInformation.main.temp.toString(), style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s48),),
                              Text(WeatherAppString.degreeCelsius, style: WeatherAppFonts.large(fontWeight: FontWeight.w700, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s24,
                                fontFeatures: [
                                  const FontFeature.enable('sups'),
                                ],

                              ),),
                            ],
                          ),

                          ///
                          /// humidty... feels like
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,

                              children: [
                                Column(

                                  children: [
                                    Image(
                                      image: Svg(WeatherAppResources.humidtyIcon),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(AppUtils.convertTextToUpper(WeatherAppString.humidityText), style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s14),),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text("${state
                                        .cityWeatherInformation.main.humidity}%", style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s14),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image(
                                      image: Svg(WeatherAppResources.windIcon),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(AppUtils.convertTextToUpper(WeatherAppString.windText), style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s14),),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text("${state
                                        .cityWeatherInformation.wind.speed}km/h", style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s14),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image(
                                      image: Svg(WeatherAppResources.feelsLike),
                                    ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(AppUtils.convertTextToUpper(WeatherAppString.feelsLikeText), style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s14),),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Text(state
                                        .cityWeatherInformation.main.feelsLike.toString(), style: WeatherAppFonts.large(fontWeight: FontWeight.w500, color: WeatherAppColor.whiteColor).copyWith(fontSize: WeatherAppFontSize.s14),),
                                  ],
                                ),

                              ],
                            ),
                          ),

                          /// forecast
                          ///

                          for(int i = 0; i < upcomingDays.length; i++)...[
                            NextWeekCard(daysOfWeek: upcomingDays[i],forecastModel: ,),
                          ]




                        ],
                      );
                    }
                    if (state is UserCityWeatherLoadingError) {
                      return Text(state.errorMessage);
                    }
                    return Container();
                  },
                )
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
