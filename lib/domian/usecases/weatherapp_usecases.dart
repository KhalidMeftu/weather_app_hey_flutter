import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherAppUseCases {
  final BaseRemoteRepository baseWeatherRepository;

  WeatherAppUseCases(this.baseWeatherRepository);


  Future<Either<String,WeatherModel>> getUserCityWeather(String cityName) async{
    return await baseWeatherRepository.getWeatherForUserCity(cityName);
  }
  Future<Either<String,WeatherModel>> getSavedCitiesWeather(List<String> cityName) async{
    return await baseWeatherRepository.getWeatherForAllCities(cityName);
  }

  Future<Either<String,String>> getCityImage(String cityName) async{
    return await baseWeatherRepository.getCityImageURL(cityName);
  }

  Future<Either<String,List<Daily>>> getDailyForecast() async{
    return await baseWeatherRepository.getDailyForecast();
  }

  /// insert user city

  Future<Either<String,List<WeatherModel>>> saveUserCity(WeatherModel weatherModel) async{
    return await baseWeatherRepository.insertWeatherModel(weatherModel);
  }

  /// fetch user city
  Future<Either<String,List<WeatherModel>>> loadUserCity() async{
    return await baseWeatherRepository.getUserCitiesWithWeather();
  }
}
