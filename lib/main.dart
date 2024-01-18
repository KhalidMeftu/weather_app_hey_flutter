import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterweatherapp/presentation/controller/HomeController/home_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/connectivity/internate_connectivity_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast_controller/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database/get_current_city_weather/load_current_city_weather_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/save_current_city%20controller/save_current_city_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/sync_data_controller/sync_database_bloc.dart';
import 'package:flutterweatherapp/routes/weather_routes.dart';
import 'const/app_locator/service_locator.dart';
import 'const/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              //
              BlocProvider(
                  create: (context) => LoadCurrentCityWeatherBloc(sLocator())),
              BlocProvider(create: (context) => InternateConnectivityBloc()),
              BlocProvider(create: (context) => SyncDatabaseBloc(sLocator())),
              BlocProvider(
                  create: (context) => SaveCurrentCityBloc(sLocator())),
              BlocProvider(create: (context) => HomeControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) => GetDailyForecastBloc(sLocator())),
              BlocProvider(
                  create: (context) => UserCityControllerBloc(sLocator())),
              BlocProvider(
                  create: (context) =>
                      GetUserCityWeatherControllerBloc(sLocator())),
            ],
            child: MaterialApp(
              title: WeatherAppString.weatherCast,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute: WeatherRoutes.splashRoute,
            ),
          );
        });
  }
}
