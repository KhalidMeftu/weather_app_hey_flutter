import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_extensions.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/services.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/const/weather_font_sizes.dart';
import 'package:flutterweatherapp/const/weather_paddings.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/common_widgets/reusable_container.dart';
import 'package:flutterweatherapp/presentation/controller/HomeController/home_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast_controller/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:home_widget/home_widget.dart';
import 'package:weather_icons/weather_icons.dart';

const String appGroupId = '<YOUR APP GROUP>';
const String iOSWidgetName = 'WeatherAppHomeScreenWidget';
const String androidWidgetName = 'WeatherAppHomeScreenWidget';

class WeatherAppHomePage extends StatefulWidget {
  bool? showDataFromSavedCities;
  WeatherModel? cityModel;

  WeatherAppHomePage({super.key, this.showDataFromSavedCities, this.cityModel});

  @override
  State<WeatherAppHomePage> createState() => _WeatherAppHomePageState();
}

class _WeatherAppHomePageState extends State<WeatherAppHomePage>
    with WidgetsBindingObserver {
  final GlobalKey<State> _permissionDialogKey = GlobalKey<State>();
  bool isGettingUserPosition = false;
  bool isLocationServiceInitialized = false;

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
  Widget build(BuildContext context) {
    List<String> upcomingDays = AppUtils.getNextFourDays();
    final forecastBloc = BlocProvider.of<GetDailyForecastBloc>(context);
    forecastBloc.add(GetDailyForCast());
    return Scaffold(
      body: widget.showDataFromSavedCities == false
          ? BlocConsumer<HomeControllerBloc, HomeControllerState>(
              buildWhen: (previous, current) {
                return previous is CurrentCityWeatherInfoLoading &&
                    current is CurrentCityDataLoaded;
              },
              builder: (context, state) {
                print("Home page Bloc");
                print(state);
                /// intial
                /// //CurrentCityDataLoaded
                if (state is CurrentCityDataLoaded) {
                  WeatherModel userCityModel = state.currentCityData;
                  userCityModel.isCurrentCity = true;
                  updateHomeScreenWidget(userCityModel);
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
                                image:
                                    NetworkImage(userCityModel.cityImageURL!),
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
                                    : Image.network(AppUtils()
                                        .getWeatherIconURL(
                                            userCityModel.weather[0].icon)),
                                10.0.sizeHeight,

                                Text(
                                  userCityModel.weather[0].description,
                                  style: WeatherAppFonts.large(
                                          fontWeight: FontWeight.w700,
                                          color: WeatherAppColor.whiteColor)
                                      .copyWith(
                                          fontSize: WeatherAppFontSize.s30),
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
                                            image: Svg(WeatherAppResources
                                                .humidtyIcon),
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
                                            image: Svg(
                                                WeatherAppResources.windIcon),
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
                                                      left: 13.w,
                                                      right: 13.w,
                                                      top: 20.h),
                                                  child: NextWeekCard(
                                                    daysOfWeek:
                                                        upcomingDays[index],
                                                    forecastModel: states
                                                        .forecastList[index],
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

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(WeatherAppPaddings.s30),
                          child: Text(WeatherAppString.loading,style: TextStyle(color: WeatherAppColor.redColor)),
                        ),
                      ),
                    ],
                  ),
                );
              },
              listener: (BuildContext context, HomeControllerState state) {
                if (state is CurrentCityWeatherInfoLoadingError) {
                  Fluttertoast.showToast(
                      msg: WeatherAppString.noCityData,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: WeatherAppFontSize.s16);
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushNamed(
                        context, WeatherRoutes.savedCitiesRoute);
                  });
                }
              },
            )
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
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!isLocationServiceInitialized) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission != LocationPermission.denied) {
          await initLocationService();
          isLocationServiceInitialized = true;
        }
      }
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
                if (mounted) {
                  Navigator.of(context).pop();
                }
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
          return;
        } else if (permission == LocationPermission.deniedForever) {
          if (mounted) Navigator.pop(context);
          return;
        }
        break;
      case LocationPermission.deniedForever:
        if (mounted) Navigator.pop(context);
        return;
      default:
        break;
    }
    await getUserPos();
  }

  Future<void> getUserPos() async {
    try {
      await getUserPosition();
    } catch (e) {
      if (mounted) permissionDialog(context);
    }
  }

  Future<void> getUserPosition() async {
    if (isGettingUserPosition) {
      return;
    }

    isGettingUserPosition = true;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> locationPlaceMark =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = locationPlaceMark[0];

      if (!mounted) {
      } else {
        print("Getting current weather");
        final userCityBloc = BlocProvider.of<HomeControllerBloc>(context);
        userCityBloc.add(GetCurrentCityWeatherInfo(place.locality!));
      }
    } finally {
      isGettingUserPosition = false;
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

  void updateHomeScreenWidget(WeatherModel newHeadline) {
    print("Weather icon URL IS${WeatherAppServices.iconURL+newHeadline.weather[0].icon+WeatherAppServices.iconSize}");
    HomeWidget.saveWidgetData<String>('city_name', newHeadline.name);
    HomeWidget.saveWidgetData<String>(
        'temprature', (newHeadline.main.temp).toString());
    HomeWidget.saveWidgetData<String>(
        'weather_icon_url', (WeatherAppServices.iconURL+newHeadline.weather[0].icon+WeatherAppServices.iconSize).toString());
    HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
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
                Navigator.pushNamed(context, WeatherRoutes.savedCitiesRoute);
              },
              child: Icon(Icons.info_outline_sharp,
                  color: WeatherAppColor.whiteColor)),
        )
      ], // Removes shadow
    );
  }
}
