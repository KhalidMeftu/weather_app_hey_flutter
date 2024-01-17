import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherAppUseCases {
  final BaseRemoteRepository baseWeatherRepository;

  WeatherAppUseCases(this.baseWeatherRepository);

  Future<Either<String,WeatherModel>> getCurrentCityWeather(String cityName) async{
    return await baseWeatherRepository.getWeatherForCurrentCity(cityName);
  }

  Future<Either<String,List<Daily>>> getDailyForecast() async{
    return await baseWeatherRepository.getDailyForecast();
  }

  Future<Either<String,WeatherModel>> saveCurrentCityWeather(WeatherModel weatherModel) async{
    return await baseWeatherRepository.saveCurrentWeatherData(weatherModel);
  }

  Future<Either<String,List<WeatherModel>>> saveUserCity(WeatherModel weatherModel) async{
    return await baseWeatherRepository.saveUserCityData(weatherModel);
  }

  Future<Either<String,WeatherModel>> getUserCityWeather(String cityName) async{
    return await baseWeatherRepository.getWeatherForUserCity(cityName);
  }

  /// fetch saved cities

  Future<Either<String,List<WeatherModel>>> loadSavedUserCities() async{
    return await baseWeatherRepository.getUserCitiesWithWeather();
  }


  // sync data
  Future<Either<String,WeatherModel>> syncUserCitiesData(String cityName, bool isCurrentCity) async{
    return await baseWeatherRepository.syncCitiesWeather(cityName,isCurrentCity);
  }
//  Future<Either<String,WeatherModel>> getCurrentCityWeather();
  Future<Either<String,WeatherModel>> getCurrentCityData() async{
    return await baseWeatherRepository.getCurrentCityWeather();
  }

}
