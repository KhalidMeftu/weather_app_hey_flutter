import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:either_dart/either.dart';

abstract class BaseRemoteDataSource {
 /// get weather for user city
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);

  /// get weather for cities all cities users saved
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName);


  /// get Image URL

Future<Either<String,String>> getCityImageURL(String cityName);

  /// get weather for forecast i fetch this from model tough

  Future<Either<String,List<Daily>>> getDailyForecast();



  /// local database crud

  /// local database

  Future<Either<String,List<WeatherModel>>> getUserCitiesWithWeather();
  Future<Either<String,List<WeatherModel>>> searchCities(String query);
  Future<Either<String,String>> insertWeatherModel(WeatherModel weatherModel);
  Future<Either<String,String>> deleteCities(WeatherModel weatherModel);
  Future<Either<String,String>>updateCitiesWeather(WeatherModel weatherModel);


}