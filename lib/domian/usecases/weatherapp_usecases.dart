import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
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
}
