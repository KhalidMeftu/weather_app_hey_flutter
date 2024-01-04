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
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_icons/weather_icons.dart';

class NewHomePage extends StatefulWidget {
  bool? showDataFromSavedCities;
  WeatherModel? cityModel;
  NewHomePage({super.key, this.showDataFromSavedCities, this.cityModel});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> with WidgetsBindingObserver {
  final GlobalKey<State> _permissionDialogKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initLocationService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await initLocationService();
    }
  }

  Future<void> initLocationService() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await showLocationServiceDialog();
    } else {
      dismissPermissionDialog();
      await handleLocationPermission();
    }
  }

  Future<void> showLocationServiceDialog() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WeatherAppString.locationDisabled),
          content: Text(WeatherAppString.pleaseEnableLocation),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
              child: Text(WeatherAppString.openSettings),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) permissionDialog(context);
        } else {
          await getUserPos();
        }
        break;
      case LocationPermission.deniedForever:
        if (mounted) Navigator.pop(context);
        break;
      default:
        await getUserPos();
    }
  }

  Future<void> getUserPos() async {
    try {
      await getUserPosition();
    } catch (e) {
      if (mounted) permissionDialog(context);
    }
  }

  Future<void> getUserPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    if (mounted) {
      final userCityBloc =
          BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
      userCityBloc.add(GetUserCityWeather(place.locality!));
    }
  }

  void permissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          key: _permissionDialogKey,
          title: Text(WeatherAppString.locationServicesDisabled),
          content: Text(WeatherAppString.locationEnable),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                getUserPos();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(WeatherAppString.okay),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(WeatherAppString.cancel),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void dismissPermissionDialog() {
    if (_permissionDialogKey.currentState != null &&
        _permissionDialogKey.currentContext != null) {
      Navigator.of(_permissionDialogKey.currentContext!).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> upcomingDays = AppUtils.getNextFourDays();
    final forecastBloc = BlocProvider.of<GetDailyForecastBloc>(context);
    forecastBloc.add(GetDailyForCast());
    return Scaffold(
      body: widget.showDataFromSavedCities == false
          ? BlocBuilder<GetUserCityWeatherControllerBloc,
                  GetUserCityWeatherControllerState>(
              buildWhen: (previous, current) {
              return previous is UserCityWeatherLoading &&
                  current is UserCityWeatherLoaded;
            }, builder: (context, state) {
              /// if city info not found show toast and navigate user to add new city page
              /// until then show shimmer

              if (state is UserCityWeatherLoaded) {
                WeatherModel userCityModel = state.cityWeatherInformation;
                userCityModel.isCurrentCity = true;
                AppUtils.saveCity(userCityModel, context);

                return Stack(
                  children: [
                    userCityModel.cityImageURL!.isEmpty
                        ? Positioned.fill(
                            child: Image.asset(
                              WeatherAppResources.cityPlaceHolder,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Positioned.fill(
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  WeatherAppResources.cityPlaceHolder),
                              image: NetworkImage(userCityModel.cityImageURL!),
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: WeatherAppBar(cityNames: userCityModel.name),
                    ),
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
                                      .copyWith(
                                          fontSize: WeatherAppFontSize.s30))),
                          2.0.sizeHeight,

                          /// updated at
                          2.0.sizeHeight,
                          Center(
                              child: Text(
                                  AppUtils.formatDateTime(userCityModel
                                      .updatedAt
                                      .toIso8601String()),
                                  style: WeatherAppFonts.large(
                                          fontWeight: FontWeight.w300,
                                          color: WeatherAppColor.whiteColor
                                              .withOpacity(0.75))
                                      .copyWith(
                                          fontSize: WeatherAppFontSize.s16))),

                          /// display data from API
                          Column(
                            children: [
                              10.0.sizeHeight,

                              AppUtils().getWeatherIcon(
                                          userCityModel.weather[0].icon) !=
                                      WeatherIcons.refresh
                                  ? Icon(
                                      AppUtils().getWeatherIcon(
                                          userCityModel.weather[0].icon),
                                      size: 100.0,
                                    )
                                  : Image.network(AppUtils().getWeatherIconURL(
                                      userCityModel.weather[0].icon)),
                              10.0.sizeHeight,

                              Text(
                                userCityModel.weather[0].description,
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
                                          text: userCityModel.main.temp
                                              .toString(),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s48),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, -8),
                                            child: Text(
                                              WeatherAppString.degreeCelsius,
                                              // The superscript part
                                              // Smaller font size for the superscript
                                              style: WeatherAppFonts.large(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: WeatherAppColor
                                                          .whiteColor)
                                                  .copyWith(
                                                fontSize:
                                                    WeatherAppFontSize.s24,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Column(
                                      children: [
                                        Image(
                                          image: Svg(
                                              WeatherAppResources.humidtyIcon),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          AppUtils.convertTextToUpper(
                                              WeatherAppString.humidityText),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          "${userCityModel.main.humidity} ${WeatherAppString.percentageText}",
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image(
                                          image:
                                              Svg(WeatherAppResources.windIcon),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          AppUtils.convertTextToUpper(
                                              WeatherAppString.windText),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          "${userCityModel.wind.speed} ${WeatherAppString.kmPerHour}",
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image(
                                          image: Svg(
                                              WeatherAppResources.feelsLike),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          AppUtils.convertTextToUpper(
                                              WeatherAppString.feelsLikeText),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          userCityModel.main.feelsLike
                                              .toString(),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
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
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                states.forecastList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 17.w,
                                                    right: 17.w,
                                                    top: 20.h),
                                                child: Center(
                                                  child: NextWeekCard(
                                                    daysOfWeek:
                                                        upcomingDays[index],
                                                    forecastModel: states
                                                        .forecastList[index],
                                                  ),
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
                );
              }

              /// with shimmer
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      WeatherAppResources.cityPlaceHolder,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.red.shade100,
                        enabled: true,
                        child: const WeatherAppBar(cityNames: "")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: ListView(
                      children: [
                        SizedBox(height: AppBar().preferredSize.height),
                        30.0.sizeHeight,

                        /// today
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.red.shade100,
                          enabled: true,
                          child: Center(
                              child: Text(AppUtils.getFormattedDate(),
                                  style: WeatherAppFonts.large(
                                          fontWeight: FontWeight.w300,
                                          color: WeatherAppColor.whiteColor)
                                      .copyWith(
                                          fontSize: WeatherAppFontSize.s30))),
                        ),
                        2.0.sizeHeight,

                        /// updated at
                        2.0.sizeHeight,
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.red.shade100,
                          enabled: true,
                          child: Center(
                              child: Text("",
                                  style: WeatherAppFonts.large(
                                          fontWeight: FontWeight.w300,
                                          color: WeatherAppColor.whiteColor
                                              .withOpacity(0.75))
                                      .copyWith(
                                          fontSize: WeatherAppFontSize.s16))),
                        ),

                        /// display data from API
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.red.shade100,
                          enabled: true,
                          child: Column(
                            children: [
                              10.0.sizeHeight,

                              Icon(
                                AppUtils().getWeatherIcon(""),
                                size: 100.0,
                              ),

                              10.0.sizeHeight,

                              Text(
                                "",
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
                                          text: "",
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s48),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, -8),
                                            child: Text(
                                              WeatherAppString.degreeCelsius,
                                              // The superscript part
                                              // Smaller font size for the superscript
                                              style: WeatherAppFonts.large(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: WeatherAppColor
                                                          .whiteColor)
                                                  .copyWith(
                                                fontSize:
                                                    WeatherAppFontSize.s24,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Column(
                                      children: [
                                        Image(
                                          image: Svg(
                                              WeatherAppResources.humidtyIcon),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          AppUtils.convertTextToUpper(
                                              WeatherAppString.humidityText),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          "",
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image(
                                          image:
                                              Svg(WeatherAppResources.windIcon),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          AppUtils.convertTextToUpper(
                                              WeatherAppString.windText),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          "",
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image(
                                          image: Svg(
                                              WeatherAppResources.feelsLike),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          AppUtils.convertTextToUpper(
                                              WeatherAppString.feelsLikeText),
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
                                        ),
                                        3.0.sizeHeight,
                                        Text(
                                          "",
                                          style: WeatherAppFonts.large(
                                                  fontWeight: FontWeight.w500,
                                                  color: WeatherAppColor
                                                      .whiteColor)
                                              .copyWith(
                                                  fontSize:
                                                      WeatherAppFontSize.s14),
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
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                states.forecastList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 17.w,
                                                    right: 17.w,
                                                    top: 20.h),
                                                child: Center(
                                                  child: NextWeekCard(
                                                    daysOfWeek:
                                                        upcomingDays[index],
                                                    forecastModel: states
                                                        .forecastList[index],
                                                  ),
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
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            })
          : Stack(
              children: [
                widget.cityModel!.cityImageURL!.isEmpty
                    ? Positioned.fill(
                        child: Image.asset(
                          WeatherAppResources.cityPlaceHolder,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Positioned.fill(
                        child: FadeInImage(
                          placeholder:
                              AssetImage(WeatherAppResources.cityPlaceHolder),
                          image: NetworkImage(widget.cityModel!.cityImageURL!),
                          fit: BoxFit.cover,
                        ),
                      ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: WeatherAppBar(cityNames: widget.cityModel!.name),
                ),
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
                      Center(
                          child: Text(
                              AppUtils.formatDateTime(widget
                                  .cityModel!.updatedAt
                                  .toIso8601String()),
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
                                      widget.cityModel!.weather[0].icon) !=
                                  WeatherIcons.refresh
                              ? Icon(
                                  AppUtils().getWeatherIcon(
                                      widget.cityModel!.weather[0].icon),
                                  size: 100.0,
                                )
                              : Image.network(AppUtils().getWeatherIconURL(
                                  widget.cityModel!.weather[0].icon)),
                          10.0.sizeHeight,

                          Text(
                            widget.cityModel!.weather[0].description,
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
                                      text: widget.cityModel!.main.temp
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
                                      "${widget.cityModel!.main.humidity} ${WeatherAppString.percentageText}",
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
                                      "${widget.cityModel!.wind.speed} ${WeatherAppString.kmPerHour}",
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
                                      widget.cityModel!.main.feelsLike
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
                                                left: 17.w,
                                                right: 17.w,
                                                top: 20.h),
                                            child: Center(
                                              child: NextWeekCard(
                                                daysOfWeek: upcomingDays[index],
                                                forecastModel:
                                                    states.forecastList[index],
                                              ),
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
