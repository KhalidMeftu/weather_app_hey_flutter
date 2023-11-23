import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutterweatherapp/const/app_color.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/const/weather_app_fonts.dart';
import 'package:flutterweatherapp/presentation/controller/getCityImage/get_city_image_controller_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  bool locationPermissionEnabled = false;
  String cityName="Uknown city";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCityImageControllerBloc,
        GetCityImageControllerState>(
      listener: (context, state) {
        if (state is CityImageLoading) {
          print("Loading city Image");
        }
        if (state is CityImageWeatherLoaded) {
          Navigator.pushNamed(
              context, WeatherRoutes.homePageRoute,
              arguments: [cityName,state.imageURL]);
        }
        if (state is CityImageLoadingError) {
          Navigator.pushNamed(
              context, WeatherRoutes.homePageRoute,
              arguments: [cityName,""]);
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
                    image: Svg(WeatherAppResources.splash_cloud),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    WeatherAppString.weatherAppEnableLocation,
                    style: WeatherAppFonts.medium(
                        color: WeatherAppColor.russianViolateColorColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Switch(
                  value: locationPermissionEnabled,
                  activeColor: WeatherAppColor.russianViolateColorColor,
                  onChanged: (bool value) async {
                    setState(() {
                      locationPermissionEnabled = value;
                    });
                    if (value == true) {
                      try {
                        Position position = await getCurrentPosition();
                        List<Placemark> placemarks =
                        await placemarkFromCoordinates(
                            position.latitude, position.longitude);
                        Placemark place = placemarks[0];
                        setState(() {
                          cityName=place.locality!;
                        });
                        print("Location is ${place.locality}");
                        await getCityImage(place.locality);
                        /*BlocListener<GetCityImageControllerBloc,
                            GetCityImageControllerState>(
                          listener: (context, state) {
                            if (state is CityImageLoading) {
                              print("Loading city Image");
                            }
                            if (state is CityImageWeatherLoaded) {
                              Navigator.pushNamed(
                                  context, WeatherRoutes.homePageRoute,
                                  arguments: [state.imageURL]);
                            }
                            if (state is CityImageLoadingError) {
                              Navigator.pushNamed(
                                  context, WeatherRoutes.homePageRoute,
                                  arguments: [""]);
                            }
                          },
                        );
                        */
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                              Text(WeatherAppString.locationServicesDisabled),
                              content: Text(WeatherAppString.locationEnable),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      locationPermissionEnabled = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(WeatherAppString.okay)),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(WeatherAppString.cancel)),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                )
              ])),
    );
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
    BlocProvider.of<GetCityImageControllerBloc>(context)
        .add(GetCityPhoto(AppUtils.convertTextToLower(locality!)));
  }
}
