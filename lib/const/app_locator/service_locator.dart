import 'package:flutterweatherapp/data/data_source/remote_data_source.dart';
import 'package:flutterweatherapp/data/remote_repository/remote_repository.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_saved_city_weather_controller/get_saved_cities_controller_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt sLocator = GetIt.instance;

class ServicesLocator {
  Future<void> init() async {
    sLocator.registerFactory(() => GetUserCityWeatherControllerBloc(sLocator()));
    sLocator.registerFactory(() => GetSavedCitiesControllerBloc(sLocator()));

    sLocator.registerLazySingleton(() =>WeatherAppUseCases(sLocator()));
    sLocator.registerLazySingleton<BaseRemoteRepository>(() => WeatherRepository(sLocator()));
    sLocator.registerLazySingleton<BaseRemoteDataSource>(() => RemoteDataSource());

  }
}