import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherRepository implements BaseRemoteRepository {
  final BaseRemoteDataSource baseremoteDataSource;

  WeatherRepository(this.baseremoteDataSource);

  @override
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    final dailyForeCast = await baseremoteDataSource.getDailyForecast();
    return dailyForeCast;
  }

  @override
  Future<Either<String, WeatherModel>> gerWeatherForCurrentCity(String cityName) async {
    // TODO: implement getWeatherForUserCity
    final currentCityWeatherResult = await baseremoteDataSource.getWeatherInfoForCurrentCity(cityName);
    return currentCityWeatherResult;
  }

  @override
  Future<Either<String, WeatherModel>> saveCurrentWeatherData(WeatherModel weatherModel) async {
    // TODO: implement saveCurrentWeatherData
    final saveCurrentCity = await baseremoteDataSource.saveCurrentCityWeatherData(weatherModel);
    return saveCurrentCity;
  }

  @override
  Future<Either<String, List<WeatherModel>>> saveUserCityData(WeatherModel weatherModel) async {
    // TODO: implement saveUserCityData
    final saveCity = await baseremoteDataSource.saveUserCityData(weatherModel);
    return saveCity;
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) async {
    // TODO: implement getWeatherForUserCity
    final resultForUserCity = await baseremoteDataSource.getWeatherForUserCity(cityName);
    return resultForUserCity;
  }

  @override
  Future <Either<String,List<WeatherModel>>> getUserCitiesWithWeather() async {
    final cityWeather = await baseremoteDataSource.getUserCitiesWithWeather();
    return cityWeather;
  }

  @override
  Future<Either<String, WeatherModel>> syncCitiesWeather(String cityName) async {
    final cityWeather = await baseremoteDataSource.syncCitiesWeather(cityName);
    return cityWeather;
  }














/* @override
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName) async {
    // TODO: implement getWeatherForAllCities
    final weatherForAllCities = await baseremoteDataSource.getWeatherForAllCities(cityName);
    return weatherForAllCities;
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) async {
    // TODO: implement getWeatherForUserCity
    final resultForUserCity = await baseremoteDataSource.getWeatherForUserCity(cityName);
    return resultForUserCity;
  }



  @override
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    final dailyForeCast = await baseremoteDataSource.getDailyForecast();
    return dailyForeCast;
  }

  @override
  Future<Either<String, String>> deleteCities(WeatherModel weatherModel) async {
    // TODO: implement deleteCities
    final deleteCities = await baseremoteDataSource.deleteCities(weatherModel);
    return deleteCities;
  }

  @override
  Future <Either<String,List<WeatherModel>>> getUserCitiesWithWeather() async {
    // TODO: implement getUserCitiesWithWeather
    final cityWeather = await baseremoteDataSource.getUserCitiesWithWeather();
    return cityWeather;
  }

  @override
  Future<Either<String, List<WeatherModel>>> SaveUserCityData(WeatherModel weatherModel) async {
    // TODO: implement insertWeatherModel
    final insertCityWeather = await baseremoteDataSource.saveUserCityDataModel(weatherModel);
    return insertCityWeather;
  }

  @override
  Future<Either<String,WeatherModel>> searchCities(String query) async {
    // TODO: implement searchCities
    final searchCity = await baseremoteDataSource.searchCities(query);
    return searchCity;
  }

  @override
  Future<Either<String,String>> updateCitiesWeather(WeatherModel weatherModel) {
    // TODO: implement updateCitiesWeather
    throw UnimplementedError();
  }

  @override
  Future<Either<String, WeatherModel>> SaveCurrentUserCityData(WeatherModel weatherModel) async {
    // TODO: implement SaveCurrentUserCityData
    final insertCityWeather = await baseremoteDataSource.saveUserCurrentCity(weatherModel);
    return insertCityWeather;
  }
*/
}