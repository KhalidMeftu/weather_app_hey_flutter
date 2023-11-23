import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/services.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
    // TODO: implement getWeatherForUserCity
    /// to capital and small
    final String cityName= await getCurrentCityName();
    final String cityImage= await getCityImageUrl1(cityName);
    print("Getting for city");
    print(cityName);
    print(cityImage);
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': WeatherAppServices.apiKey,
    };
    try {
      Response response = await dio.get(
          WeatherAppServices.baseURL, queryParameters: queryParameters);
      final requestUri = response.requestOptions.uri;
      print('GET URL: $requestUri');

      if (response.statusCode == 200) {
        final data = WeatherModel.fromJson(response.data);
        if (cityImage != WeatherAppString.noData) {
          data.cityImageURL = cityImage;
        }
        else {
          data.cityImageURL = "";
        }
        print("Response is111 ");
        print(data.toString());
        return Right(data);
      }
      else {
        return Left('Error: ${response.data}');
      }
    }
    catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          print("DIO exception");
          print(e.response!);
          return Left(e.response!.data['data']);
        } else {
          return Left(e.message!);
        }
      }
      return (Left(
          e.toString())); // Rethrow the exception to propagate it further
    }
  }

  @override
  Future<Either<String, String>> getCityImageURL(String cityName) {
    // TODO: implement getCityImageURL
   // getCurrentCityName();
    throw UnimplementedError();
  }

  Future<String> getCurrentCityName() async {
    try {
      Position currentPosition = await getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = placemarks[0];
      return place.locality!;
    }
    on Exception catch (_, ex) {

      return ex.toString();
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(WeatherAppString.locationServicesDisabled);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          WeatherAppString.locationServicesUnableToGet);
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future<String>getCityImageUrl1(String cityName) async {
    String url = WeatherAppServices.cityImageApi+cityName+WeatherAppServices.cityImageApiImage;
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        var imageData = response.data['photos'][0]['image']['mobile'];
        return imageData;
      } else {
        // Request failed
        return WeatherAppString.noData;
      }
    }
    catch (e) {
    if (e is DioException) {
    if (e.response != null) {
    print("DIO exceptionCityImage");
    print(e.response!);
    return "";
    } else {
    return" Left(e.message!)";
    }
    }
    return (""); // Rethrow the exception to propagate it further
    }
  }

}
