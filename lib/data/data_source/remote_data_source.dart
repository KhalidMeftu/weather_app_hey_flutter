import 'package:either_dart/src/either.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class RemoteDataSource extends BaseRemoteDataSource {
  @override
  Future<Either<String, WeatherModel>> getWeatherForAllCities(
      List<String> cityName) {
    // TODO: implement getWeatherForAllCities

    throw UnimplementedError();
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName) {
    // TODO: implement getWeatherForUserCity
    getCurrentCityName();
    throw UnimplementedError();
  }

  @override
  Future<Either<String, String>> getCityImageURL(String cityName) {
    // TODO: implement getCityImageURL
    getCurrentCityName();
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
}
