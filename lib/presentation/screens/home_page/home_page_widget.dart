import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/utils.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/presentation/controller/HomeController/home_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/connectivity/internate_connectivity_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_widgets/home_default_widget.dart';
import 'home_widgets/home_loaded_widget.dart';
import 'home_widgets/home_utils.dart';
import 'home_widgets/saved_city_widget.dart';

class WeatherAppHomePage extends StatefulWidget {
  bool? showDataFromSavedCities;
  WeatherModel? cityModel;

  WeatherAppHomePage({super.key, this.showDataFromSavedCities, this.cityModel});

  @override
  State<WeatherAppHomePage> createState() => _WeatherAppHomePageState();
}

class _WeatherAppHomePageState extends State<WeatherAppHomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey<State> permissionDialogKey = GlobalKey<State>();
  bool isGettingUserPosition = false;
  bool isLocationServiceInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!widget.showDataFromSavedCities!) {
      initLocationService();
    } else {
      if (kDebugMode) {
        print("City Images");
        print(widget.cityModel?.cityImageURL);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> upcomingDays =  HomeUtils.getDailyForecast(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: widget.showDataFromSavedCities == false
            ? BlocBuilder<InternateConnectivityBloc, InternateConnectivityState>(
          builder: (context, state) {
            if (state is ConnectedState) {
              return BlocConsumer<HomeControllerBloc, HomeControllerState>(
                buildWhen: (previous, current) {
                  return (previous is CurrentCityWeatherInfoLoading && current is CurrentCityDataLoaded) ||
                      (current is CurrentCityDataLoaded && previous is CurrentCityDataLoaded);
                },
                listenWhen: (previous, current) {
                  return previous != current;
                },
                builder: (context, state) {
                  if (state is CurrentCityDataLoaded) {
                    WeatherModel weatherCityModel = state.currentCityData;
                    weatherCityModel.isCurrentCity = true;
                    AppUtils.updateHomeScreenWidget(weatherCityModel);
                    AppUtils.saveCity(weatherCityModel, context);

                    return CurrentCityLoadedUIWidget(
                      weatherCityModel: weatherCityModel,
                      upcomingDays: upcomingDays,
                    );
                  }

                  return DefaultUIWidget(isLocationServiceInitialized: isLocationServiceInitialized,);
                },
                listener: (BuildContext context, HomeControllerState state) {
                  if (state is CurrentCityWeatherInfoLoadingError) {
                    AppUtils.showToastMessage(WeatherAppString.noCityData, Toast.LENGTH_SHORT);
                    final initInitialState = BlocProvider.of<HomeControllerBloc>(context);
                    initInitialState.add(GetInitialEvent());
                    Future.delayed(const Duration(seconds: 2), () {
                      HomeUtils.goToSavedList(true, context);
                    });
                  }
                },
              );
            } else if (state is NotConnectedState) {
              // Handle not connected state
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(WeatherAppResources.connectivityLottie),
                ],
              );
            }

            return Container();
          },
        )
            : SavedCityWidget(
          upcomingDays: upcomingDays,
          cityModel: widget.cityModel!,
        ),
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
        } else {
          await initLocationService();
        }
      }
    }
  }

  Future<void> initLocationService() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        await  HomeUtils.showLocationServiceDialog(context, mounted);
      }
    } else {
      dismissPermissionDialog();
      await handleLocationPermission();
    }
  }

  Future<void> handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            HomeUtils.permissionDialog(context, permissionDialogKey, mounted,
                isGettingUserPosition, widget.showDataFromSavedCities);
          }
          return;
        } else if (permission == LocationPermission.deniedForever) {
          if (mounted) {
            await openAppSettings();
          }
          return;
        }
        break;
      case LocationPermission.deniedForever:
        if (mounted) {
          await openAppSettings();
        }
        return;
      default:
        break;
    }
    if (mounted) {
      isLocationServiceInitialized = true;

      await  HomeUtils.getPosition(context, mounted, permissionDialogKey,
          isGettingUserPosition, widget.showDataFromSavedCities);
    }
  }

  void dismissPermissionDialog() {
    if (permissionDialogKey.currentState != null && permissionDialogKey.currentContext != null) {
      Navigator.of(permissionDialogKey.currentContext!).pop();
    }
  }
}
