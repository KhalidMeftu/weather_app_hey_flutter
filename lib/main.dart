import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/presentation/controller/getCityImage/get_city_image_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_saved_city_weather_controller/get_saved_cities_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';

import 'const/app_locator/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              /// as soon as app started i need to get user current city data
              /// GetDailyForecastBloc
              /// UserCityControllerBloc
              BlocProvider(
                  create: (context) =>
                      GetDailyForecastBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      UserCityControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetUserCityWeatherControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetSavedCitiesControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetCityImageControllerBloc(sLocator())),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute:WeatherRoutes.splashRoute, //WeatherRoutes.userCitiesRoute,//WeatherRoutes.splashRoute,
            ),
          );
        });
  }
}


