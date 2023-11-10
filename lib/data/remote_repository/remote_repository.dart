import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/base_repository/base_repository.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class WeatherRepository implements BaseRemoteRepository {
  final BaseRemoteDataSource baseremoteDataSource;

  WeatherRepository(this.baseremoteDataSource);
  @override
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName) async {
    // TODO: implement getWeatherForAllCities
    final result = await baseremoteDataSource.getWeatherForAllCities(cityName);
    return result;
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) async {
    // TODO: implement getWeatherForUserCity
    final result = await baseremoteDataSource.getWeatherForUserCity(cityName);
    return result;
  }
  
}