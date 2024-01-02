import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_locator/service_locator.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/sharedPrefs/sharedprefsservice.dart';
import 'package:flutterweatherapp/const/weather_paddings.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  bool locationPermissionEnabled = false;
  String cityName = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addObserver(this);
    checkPermissionOrAskLocationService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await checkPermissionOrAskLocationService();
    }
  }

  Future<void> checkPermissionOrAskLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      askForLocationPermission();
    } else {
      checkAndRequestLocationService();
    }
  }

  Future<void> askForLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          permissionDialog(context);
        }
      } else {
        getUserPos();
      }
    } else if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      getUserPos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetUserCityWeatherControllerBloc,
            GetUserCityWeatherControllerState>(listenWhen: (previous, current) {
          return previous is UserCityWeatherLoading &&
              current is UserCityWeatherLoaded;
        }, listener: (context, state1) async {
          if (state1 is UserCityWeatherLoaded) {
            WeatherModel newModel = state1.cityWeatherInformation;
            newModel.isCurrentCity = true;
            await saveCityToSharedPrefs(newModel, context);
            if (!mounted) {
              return;
            }
            saveCity(newModel, context);
          }
        }),
        BlocListener<UserCityControllerBloc, UserCityControllerState>(
            listener: (context, state2) async {
          if (state2 is CurrentCitySaveSuccessfull) {
            Navigator.pushNamed(context, WeatherRoutes.homePageRoute,
                arguments: [state2.weatherModel]);
          }
          if (state2 is CurrentCitySavingResponse) {
            // todo for fetch error
          }
        })
      ],
      child: Scaffold(
          backgroundColor: WeatherAppColor.russianViolateColorColor,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(WeatherAppPaddings.s14),
                  child: Image(
                    image: Svg(WeatherAppResources.splashCloud),
                  ),
                ),
              ])),
    );
  }

  void permissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WeatherAppString.locationServicesDisabled),
          content: Text(WeatherAppString.locationEnable),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                setState(() {
                  locationPermissionEnabled = false;
                });
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

  Future<void> getUserPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return;
    }

    Position position = await getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    setState(() {
      cityName = place.locality!;
    });
    await getCityImage(cityName);
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(WeatherAppString.locationServicesDisabled);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(WeatherAppString.locationDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(WeatherAppString.locationPermanentlyDenied);
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future getCityImage(String? locality) async {
    final userCityBloc =
        BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
    userCityBloc.add(GetUserCityWeather(locality!));
  }

  Future<void> getUserPos() async {
    try {
      await getUserPosition();
    } catch (e) {
      if (!mounted) {
        return;
      }
      permissionDialog(context);
    }
  }

  Future<void> checkAndRequestLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) {
        return;
      }

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
                  child: Text(WeatherAppString.openSettings))
            ],
          );
        },
      );
    } else {
      getUserPos();
    }
  }

  Future<void> saveCityToSharedPrefs(
      WeatherModel newModel, BuildContext context) async {
    LocalStorageServices localStorageServices =
        sLocator<LocalStorageServices>();
    await localStorageServices.saveUserCurrentCity(newModel);
    if (!mounted) {
      /// note If the widget is no longer in the widget tree, do not continue
      return;
    }
  }

  /// save data to database

  void saveCity(WeatherModel cityWeatherInformation, BuildContext context) {
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(SaveCurrentCity(cityWeatherInformation));
  }
}
