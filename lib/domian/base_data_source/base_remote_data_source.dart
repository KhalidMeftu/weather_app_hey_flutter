import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:either_dart/either.dart';

abstract class BaseRemoteDataSource {
  /// get weather for current city
  Future<Either<String, WeatherModel>> getWeatherInfoForCurrentCity(String cityName);
  /// get 4 days weather forecast
  Future<Either<String,List<Daily>>> getDailyForecast();
  /// save current city to database
  Future<Either<String,WeatherModel>> saveCurrentCityWeatherData(WeatherModel weatherModel);
  /// get saved cities
  Future<Either<String,List<WeatherModel>>> saveUserCityData(WeatherModel weatherModel);
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);
  Future<Either<String,List<WeatherModel>>> getUserCitiesWithWeather();
  /// sync all data
  Future<Either<String,WeatherModel>> syncCitiesWeather(String cityName, bool isCurrentCity);
  Future<Either<String,WeatherModel>> getCurrentCityWeather();


}