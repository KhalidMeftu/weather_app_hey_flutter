import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

abstract class BaseRemoteRepository{
  /// get weather for user city
  /* Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);

  /// get weather for forcaset i fetch this from model tough
  Future<Either<String,List<Daily>>> getDailyForecast();
  /// local database related

 Future<Either<String,List<WeatherModel>>> getUserCitiesWithWeather();
  Future<Either<String,WeatherModel>> searchCities(String query);
  Future<Either<String,List<WeatherModel>>> SaveUserCityData(WeatherModel weatherModel);
  Future<Either<String,String>> deleteCities(WeatherModel weatherModel);
  Future<Either<String,String>>updateCitiesWeather(WeatherModel weatherModel);
  Future<Either<String,WeatherModel>> SaveCurrentUserCityData(WeatherModel weatherModel);
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName);
  */


  /// get weather for current city
  Future<Either<String, WeatherModel>> gerWeatherForCurrentCity(String cityName);

  /// get 4 days weather forecast
  Future<Either<String,List<Daily>>> getDailyForecast();

  /// save current city to database
  Future<Either<String,WeatherModel>> saveCurrentWeatherData(WeatherModel weatherModel);


  /// get saved cities
  Future<Either<String,List<WeatherModel>>> saveUserCityData(WeatherModel weatherModel);
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);
  Future<Either<String,List<WeatherModel>>> getUserCitiesWithWeather();






}