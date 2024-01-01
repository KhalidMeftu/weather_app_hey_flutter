import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_locator/service_locator.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/sharedPrefs/sharedprefsservice.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
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
    WidgetsBinding.instance!.addObserver(this);
    checkAndRequestLocationService();

  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {

        askForLocationPermission();

      } else {
        checkAndRequestLocationService();
      }

    }

  }
  Future<void> askForLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permissionDialog(context);
      } else {
        getUserPos();
      }
    } else if (permission == LocationPermission.deniedForever) {

    } else {
      getUserPos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUserCityWeatherControllerBloc,
        GetUserCityWeatherControllerState>(
      listener: (context, state1) {
        if (state1 is UserCityWeatherLoaded) {
          WeatherModel newModel = state1.cityWeatherInformation;
          newModel.isCurrentCity = true;
          saveCityToSharedPrefs(newModel, context);
        }
      },
      child: Scaffold(
          backgroundColor: WeatherAppColor.whiteColor,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
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
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future getCityImage(String? locality) async {
    final userCityBloc =  BlocProvider.of<GetUserCityWeatherControllerBloc>(context);
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
        // If the widget is no longer in the widget tree, do not continue
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Service Disabled"),
            content: Text("Please enable location services to use this feature."),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    Navigator.of(context).pop();
                  },
                  child: Text("Open Settings")
              )
            ],
          );
        },
      );
    } else {
      getUserPos();
    }
  }

  Future<void> saveCityToSharedPrefs(WeatherModel newModel, BuildContext context) async {
    LocalStorageServices localStorageServices = sLocator<LocalStorageServices>();
    bool saveResult = await localStorageServices.saveCurrentCity(newModel);

    if (!mounted) {
      /// note If the widget is no longer in the widget tree, do not continue
      return;
    }

    if (saveResult) {
      Navigator.pushNamed(context, WeatherRoutes.homePageRoute, arguments: [newModel]);
    } else {
      // Handle error
    }
  }

}


