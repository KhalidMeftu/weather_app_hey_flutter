import 'package:either_dart/either.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherAppUseCases {
  final BaseRemoteRepository baseWeatherRepository;

  WeatherAppUseCases(this.baseWeatherRepository);
  /// daily forcast

  Future<Either<String,WeatherModel>> getCurrentCityWeather(String cityName) async{
    return await baseWeatherRepository.gerWeatherForCurrentCity(cityName);
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


/*

  Future<Either<String,WeatherModel>> getUserCityWeather(String cityName) async{
    return await baseWeatherRepository.getWeatherForUserCity(cityName);
  }
  Future<Either<String,WeatherModel>> getSavedCitiesWeather(List<String> cityName) async{
    return await baseWeatherRepository.getWeatherForAllCities(cityName);
  }


  Future<Either<String,List<Daily>>> getDailyForecast() async{
    return await baseWeatherRepository.getDailyForecast();
  }

  /// insert user city

  Future<Either<String,List<WeatherModel>>> saveUserCity(WeatherModel weatherModel) async{
    return await baseWeatherRepository.SaveUserCityData(weatherModel);
  }

  /// fetch user city
  Future<Either<String,List<WeatherModel>>> loadSavedUserCities() async{
    return await baseWeatherRepository.getUserCitiesWithWeather();
  }

  /// search usercity

  Future<Either<String,WeatherModel>> searchCity(String cityName) async{
    return await baseWeatherRepository.searchCities(cityName);
  }


  /// current city

  Future<Either<String,WeatherModel>> saveUserCurrentCity(WeatherModel weatherModel) async{
    return await baseWeatherRepository.SaveCurrentUserCityData(weatherModel);
  }

*/


}
