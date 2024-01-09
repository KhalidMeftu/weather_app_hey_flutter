import 'package:flutterweatherapp/const/database/app_database.dart';
import 'package:flutterweatherapp/const/sharedPrefs/sharedprefsservice.dart';
import 'package:flutterweatherapp/data/data_source/remote_data_source.dart';
import 'package:flutterweatherapp/data/remote_repository/remote_repository.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';
import 'package:flutterweatherapp/presentation/controller/HomeController/home_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_daily_forecast_controller/get_daily_forecast_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/local_database_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/save_current_city%20controller/save_current_city_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt sLocator = GetIt.instance;

class ServicesLocator {
  Future<void> init() async {
//
    sLocator.registerFactory(() => SaveCurrentCityBloc(sLocator()));
    sLocator.registerFactory(() => HomeControllerBloc(sLocator()));
    sLocator.registerFactory(() => UserCityControllerBloc(sLocator()));
    sLocator.registerFactory(() => GetDailyForecastBloc(sLocator()));
    sLocator.registerFactory(() => GetUserCityWeatherControllerBloc(sLocator()));
    sLocator.registerLazySingleton(() =>WeatherAppUseCases(sLocator()));
    sLocator.registerLazySingleton<BaseRemoteRepository>(() => WeatherRepository(sLocator()));
    sLocator.registerLazySingleton<BaseRemoteDataSource>(() => RemoteDataSource());
    /// todo shared prrefs
    sLocator.registerLazySingleton(() => AppDatabase.instance);
    var instance = await LocalStorageServices.getinstance();
    sLocator.registerLazySingleton<LocalStorageServices>(() => instance);

  }
}