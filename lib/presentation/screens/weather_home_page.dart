import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_extensions.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/common_widgets/reusable_container.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:weather_icons/weather_icons.dart';

import '../controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';

class WeatherHomePage extends StatefulWidget {
  final String cityName;
  final String imageUrl;
  WeatherModel? weatherModel;

  /// this is when we come back fromsaved

  WeatherHomePage({Key? key,
    required this.cityName,
    required this.imageUrl,
    this.weatherModel})
      : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  /// load next for days
  List<String> upcomingDays = AppUtils.getNextFourDays();

  ///
  @override
  void initState() {
    // TODO: implement initState
    /// forecast bloc so if weather model is empty only we will do call to internate
    final forecastBloc = BlocProvider.of<GetDailyForecastBloc>(context);
    forecastBloc.add(GetDailyForCast());
    if (widget.weatherModel == null) {
      final userCityBloc =
      BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
      userCityBloc.add(GetUserCityWeather(widget.cityName));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

        Stack(
          children: [
            /// some city's image not found example addis ababa so if we have null image we will display default city image
              widget.imageUrl.isEmpty
                  ? Positioned.fill(
                child: Image.asset(
                  WeatherAppResources.cityPlaceHolder,
                  fit: BoxFit.cover,
                ),
              )
                  : Positioned.fill(
                child: FadeInImage(
                  placeholder: AssetImage(WeatherAppResources.cityPlaceHolder),
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: WeatherAppBar(cityNames: widget.weatherModel == null
                  ? widget.cityName
                  : widget.weatherModel!.name,),
            ),
            //Center(child: widget.weatherModel==null?Container():Text(widget.weatherModel!.cityImageURL??"", style: TextStyle(color:Colors.white,fontSize: 50),)),
            Padding(
              padding: EdgeInsets.only(top: 80.h),
              child: ListView(
                children: [
                  SizedBox(height: AppBar().preferredSize.height),
                  30.0.sizeHeight,

                  /// today
                  Center(
                      child: Text(AppUtils.getFormattedDate(),
                          style: WeatherAppFonts.large(
                              fontWeight: FontWeight.w300,
                              color: WeatherAppColor.whiteColor)
                              .copyWith(fontSize: WeatherAppFontSize.s30))),
                  2.0.sizeHeight,

                  /// updated at
                  2.0.sizeHeight,
                  widget.weatherModel == null
                      ? Container()
                      : Center(
                      child: Text(
                          AppUtils.formatDateTime(widget
                              .weatherModel!.updatedAt
                              .toIso8601String()),
                          style: WeatherAppFonts.large(
                              fontWeight: FontWeight.w300,
                              color: WeatherAppColor.whiteColor
                                  .withOpacity(0.75))
                              .copyWith(fontSize: WeatherAppFontSize.s16))),

                  /// display data from API
                  widget.weatherModel == null
                      ? BlocBuilder<GetUserCityWeatherControllerBloc,
                      GetUserCityWeatherControllerState>(
                    builder: (context, state) {
                      if (state is UserCityWeatherLoading) {
                        return AppUtils().loadingSpinner;
                      }
                      if (state is UserCityWeatherLoaded) {

                        saveCity(state.cityWeatherInformation, context, state.cityImageURL);
                        return WeatherDataDisplay(
                            weatherModel: state.cityWeatherInformation);
                      }
                      if (state is UserCityWeatherLoadingError) {
                        return Text(state.errorMessage);
                      }
                      return Container();
                    },
                  )
                      : Column(
                    children: [
                      10.0.sizeHeight,

                      AppUtils().getWeatherIcon(
                          widget.weatherModel!.weather[0].icon) !=
                          WeatherIcons.refresh
                          ? Icon(
                        AppUtils().getWeatherIcon(
                            widget.weatherModel!.weather[0].icon),
                        size: 100.0,
                      )
                          : Image.network(AppUtils().getWeatherIconURL(
                          widget.weatherModel!.weather[0].icon)),
                      10.0.sizeHeight,

                      Text(
                        widget.weatherModel!.weather[0].description,
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
                                  text: widget.weatherModel!.main.temp
                                      .toString(),
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
                                  "${widget.weatherModel!.main.humidity}%",
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
                                  "${widget.weatherModel!.wind.speed}km/h",
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
                                  widget.weatherModel!.main.feelsLike
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

                      /// forecast
                      ///

                      BlocBuilder<GetDailyForecastBloc,
                          GetDailyForecastState>(
                          builder: (context, states) {
                            if (states is LoadingDailyForecast) {}
                            if (states is DailyForecastLoaded) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: SizedBox(
                                    height: 200.h,
                                    child: GlassContainer(
                                      color: WeatherAppColor.whiteColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: states.forecastList.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 12.w,
                                                right: 12.w,
                                                top: 15.h),
                                            child: NextWeekCard(
                                              daysOfWeek: upcomingDays[index],
                                              forecastModel:
                                              states.forecastList[index],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Container();
                          })
                    ],
                  )
                ],
              ),
            ),


          ],
        ),

    );
  }

  void saveCity(WeatherModel cityWeatherInformation, BuildContext context, String cityImageURL) {
    WeatherModel newModel = cityWeatherInformation;
    newModel.cityImageURL=cityImageURL;
    BlocProvider.of<UserCityControllerBloc>(context)
        .add(InsertUserCity(newModel));
  }
}

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
                Navigator.pushNamed(context, WeatherRoutes.userCitiesRoute);
              },
              child: Icon(Icons.menu, color: WeatherAppColor.whiteColor)),
        )
      ], // Removes shadow
    );
  }
}

class WeatherDataDisplay extends StatelessWidget {
  final WeatherModel weatherModel;

  const WeatherDataDisplay({Key? key, required this.weatherModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> upcomingDays = AppUtils.getNextFourDays();

    return Column(
      children: [
        10.0.sizeHeight,

        AppUtils().getWeatherIcon(weatherModel.weather[0].icon) !=
            WeatherIcons.refresh
            ? Icon(
          AppUtils().getWeatherIcon(weatherModel.weather[0].icon),
          size: 100.0,
        )
            : Image.network(
            AppUtils().getWeatherIconURL(weatherModel.weather[0].icon)),
        10.0.sizeHeight,

        Text(
          weatherModel.weather[0].description,
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
                    text: weatherModel.main.temp.toString(),
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s48),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(2, -8),
                      child: Text(
                        WeatherAppString.degreeCelsius, // The superscript part
                        // Smaller font size for the superscript
                        style: WeatherAppFonts.large(
                            fontWeight: FontWeight.w700,
                            color: WeatherAppColor.whiteColor)
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
                    image: Svg(WeatherAppResources.humidtyIcon),
                  ),
                  3.0.sizeHeight,
                  Text(
                    AppUtils.convertTextToUpper(WeatherAppString.humidityText),
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s14),
                  ),
                  3.0.sizeHeight,
                  Text(
                    "${weatherModel.main.humidity}%",
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s14),
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
                    AppUtils.convertTextToUpper(WeatherAppString.windText),
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s14),
                  ),
                  3.0.sizeHeight,
                  Text(
                    "${weatherModel.wind.speed}km/h",
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s14),
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
                    AppUtils.convertTextToUpper(WeatherAppString.feelsLikeText),
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s14),
                  ),
                  3.0.sizeHeight,
                  Text(
                    weatherModel.main.feelsLike.toString(),
                    style: WeatherAppFonts.large(
                        fontWeight: FontWeight.w500,
                        color: WeatherAppColor.whiteColor)
                        .copyWith(fontSize: WeatherAppFontSize.s14),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// forecast
        ///

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
                        color: WeatherAppColor.whiteColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: states.forecastList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 12.w, right: 12.w, top: 15.h),
                              child: NextWeekCard(
                                daysOfWeek: upcomingDays[index],
                                forecastModel: states.forecastList[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (states is DailyForcastLoadingError) {}
              return Container();
            })
      ],
    );
  }
}
