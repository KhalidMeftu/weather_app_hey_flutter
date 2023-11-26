import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

abstract class BaseRemoteRepository{
  /// get weather for user city
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);

  /// get weather for cities all cities users saved
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName);

  Future<Either<String,String>> getCityImageURL(String cityName);

  /// get weather for forcaset i fetch this from model tough

  Future<Either<String,List<Daily>>> getDailyForecast();



}