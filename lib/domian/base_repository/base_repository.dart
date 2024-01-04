import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

abstract class BaseRemoteRepository{
  /// get weather for user city
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);
  /// get weather for cities all cities users saved
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName);
  /// get weather for forcaset i fetch this from model tough
  Future<Either<String,List<Daily>>> getDailyForecast();
  /// local database
  Future<Either<String,List<WeatherModel>>> getUserCitiesWithWeather();
  Future<Either<String,WeatherModel>> searchCities(String query);
  Future<Either<String,List<WeatherModel>>> SaveUserCityData(WeatherModel weatherModel);
  Future<Either<String,String>> deleteCities(WeatherModel weatherModel);
  Future<Either<String,String>>updateCitiesWeather(WeatherModel weatherModel);
  Future<Either<String,WeatherModel>> SaveCurrentUserCityData(WeatherModel weatherModel);







}