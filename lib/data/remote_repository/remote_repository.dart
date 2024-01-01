import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherRepository implements BaseRemoteRepository {
  final BaseRemoteDataSource baseremoteDataSource;

  WeatherRepository(this.baseremoteDataSource);
  @override
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
  Future<Either<String, String>> getCityImageURL(String cityName) async {
    // TODO: implement getCityImageURL
    final cityImageURL = await baseremoteDataSource.getCityImageURL(cityName);
    return cityImageURL;
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
  Future<Either<String, List<WeatherModel>>> insertWeatherModel(WeatherModel weatherModel) async {
    // TODO: implement insertWeatherModel
    final insertCityWeather = await baseremoteDataSource.insertWeatherModel(weatherModel);
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

}