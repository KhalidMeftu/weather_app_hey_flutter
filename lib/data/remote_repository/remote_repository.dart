import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherRepository implements BaseRemoteRepository {
  final BaseRemoteDataSource baseRemoteDataSource;

  WeatherRepository(this.baseRemoteDataSource);

  @override
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    final dailyForeCast = await baseRemoteDataSource.getDailyForecast();
    return dailyForeCast;
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForCurrentCity(String cityName) async {
    // TODO: implement getWeatherForUserCity
    final currentCityWeatherResult = await baseRemoteDataSource.getWeatherInfoForCurrentCity(cityName);
    return currentCityWeatherResult;
  }

  @override
  Future<Either<String, WeatherModel>> saveCurrentWeatherData(WeatherModel weatherModel) async {
    // TODO: implement saveCurrentWeatherData
    final saveCurrentCity = await baseRemoteDataSource.saveCurrentCityWeatherData(weatherModel);
    return saveCurrentCity;
  }

  @override
  Future<Either<String, List<WeatherModel>>> saveUserCityData(WeatherModel weatherModel) async {
    // TODO: implement saveUserCityData
    final saveCity = await baseRemoteDataSource.saveUserCityData(weatherModel);
    return saveCity;
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) async {
    // TODO: implement getWeatherForUserCity
    final resultForUserCity = await baseRemoteDataSource.getWeatherForUserCity(cityName);
    return resultForUserCity;
  }

  @override
  Future <Either<String,List<WeatherModel>>> getUserCitiesWithWeather() async {
    final cityWeather = await baseRemoteDataSource.getUserCitiesWithWeather();
    return cityWeather;
  }

  @override
  Future<Either<String, WeatherModel>> syncCitiesWeather(String cityName, bool isCurrentCity) async {
    final cityWeather = await baseRemoteDataSource.syncCitiesWeather(cityName, isCurrentCity);
    return cityWeather;
  }

  @override
  Future<Either<String, WeatherModel>> getCurrentCityWeather() async {
    // TODO: implement getCurrentCityWeather
    final cityWeather = await baseRemoteDataSource.getCurrentCityWeather();
    return cityWeather;
  }













}