import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/services.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';


class RemoteDataSource extends BaseRemoteDataSource {
  Dio dio = Dio();

  @override
  Future<Either<String, WeatherModel>> getWeatherForAllCities(
      List<String> cityName) {
    // TODO: implement getWeatherForAllCities

    throw UnimplementedError();
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) async {
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': WeatherAppServices.apiKey, // Ensure secure handling of API Key
    };

    try {
      Response response = await Dio().get(
          WeatherAppServices.baseURL, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        print("Response is ");
        print(response.data);
        final data = WeatherModel.fromJson(response.data);
        return Right(data);
      } else {
        return Left('Error: Server responded with status code ${response.statusCode}');
      }
    } catch (e, s) {
      if (e is DioException) {
        return Left('Error: ${e.response?.data['message'] ?? e.message}');
      }
      // Optionally log the stack trace for debugging
      print(s);
      return const Left('Error: An unexpected error occurred');
    }
  }
  @override
  Future<Either<String, String>> getCityImageURL(String cityName) async {
    String url = WeatherAppServices.cityImageApi + cityName + WeatherAppServices.cityImageApiImage;
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        if (response.data.containsKey('photos') && response.data['photos'].isNotEmpty) {
          var imageData = response.data['photos'][0]['image']['mobile'];
          return Right(imageData); // Using Either
        } else {
          return Left(WeatherAppString.noData); // No data found
        }
      } else {
        return Left('Error: Unexpected response status code ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        return Left('DioException: ${e.message}');
      } else {
        return Left('Exception: ${e.toString()}');
      }
    }
  }




}
