import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

abstract class BaseRemoteRepository{
  /// get weather for user city
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);

  /// get weather for cities all cities users saved
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName);

}