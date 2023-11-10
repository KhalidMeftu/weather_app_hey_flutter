import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

class RemoteDataSource extends BaseRemoteDataSource {
  @override
  Future<Either<String, WeatherModel>> getWeatherForAllCities(List<String> cityName) {
    // TODO: implement getWeatherForAllCities
    throw UnimplementedError();
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) {
    // TODO: implement getWeatherForUserCity
    throw UnimplementedError();
  }
  
}