import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/services.dart';
import 'package:flutterweatherapp/const/app_strings.dart';
import 'package:flutterweatherapp/const/database/app_database.dart';
import 'package:flutterweatherapp/const/services.dart';
import 'package:flutterweatherapp/domian/base_data_source/base_remote_data_source.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class RemoteDataSource extends BaseRemoteDataSource {
  final AppDatabase _appDatabase;
  Dio dio = Dio();
  static const String CityName = 'cities';
  final cityNameStore = intMapStoreFactory.store(CityName);

  RemoteDataSource() : _appDatabase = GetIt.instance<AppDatabase>();

  Future<Database> get _db async => await _appDatabase.database;

  @override
  Future<Either<String, WeatherModel>> getWeatherForAllCities(
      List<String> cityName) {
    // TODO: implement getWeatherForAllCities

    throw UnimplementedError();
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(
      String cityName) async {
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': WeatherAppServices.apiKey, // Ensure secure handling of API Key
    };

    try {
      Response response = await Dio()
          .get(WeatherAppServices.baseURL, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final data = WeatherModel.fromJson(response.data);
        final cityImage = await getCityImage(cityName);
        data.cityImageURL = cityImage;
        return Right(data);
      } else {
        return Left(
            'Error: Server responded with status code ${response.statusCode}');
      }
    } catch (e, s) {
      if (e is DioException) {
        return Left('Error: ${e.response?.data['message'] ?? e.message}');
      }
      return const Left('Error: An unexpected error occurred');
    }
  }



  @override
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    try {
      /// a 2-second delay to mock web response
      await Future.delayed(const Duration(seconds: 1));
      final String response =
          await rootBundle.loadString('assets/json/mockdailyforecast.json');
      final data = json.decode(response);

      if (data is Map<String, dynamic> && data.containsKey('daily')) {
        final dailyData = List<Map<String, dynamic>>.from(data['daily']);
        List<Daily> dailyList =
            dailyData.map((json) => Daily.fromJson(json)).toList();
        return Right(dailyList);
      } else {
        return const Left('Invalid JSON format');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// delete city
  @override
  Future<Either<String, String>> deleteCities(WeatherModel weatherModel) {
    // TODO: implement deleteCities
    throw UnimplementedError();
  }

  /// get all cities info
  @override
  Future<Either<String, List<WeatherModel>>> getUserCitiesWithWeather() async {
    return await populateWeatherDatabase();
  }

  /// insert ops
  @override
  Future<Either<String, List<WeatherModel>>> saveUserCityDataModel(
    WeatherModel weatherModel,
  ) async {
    try {
      final cityNameNormalized = normalizeCityName(weatherModel.name);
      final existingRecords = await cityNameStore.find(
        await _db,
        finder: Finder(
          filter: Filter.custom((record) {
            final recordNameNormalized =
                normalizeCityName(record['name'] as String);
            return recordNameNormalized == cityNameNormalized;
          }),
        ),
      );

      if (existingRecords.isNotEmpty) {
        return const Left('Insert failed: cityName already exists');
      }
      await cityNameStore.add(await _db, weatherModel.toJson());
      final allRecords = await cityNameStore.find(await _db);
      final weatherModels = allRecords.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      return Left('Insert failed: ${e.toString()}');
    }
  }

  String normalizeCityName(String name) {
    return name.toLowerCase().trim();
  }

  /// search
  @override
  Future<Either<String, WeatherModel>> searchCities(String query) async {
    try {
      final finder = Finder(
        filter: Filter.custom((record) {
          final cityName = record['name'] as String;
          return cityName.toLowerCase().contains(query.toLowerCase());
        }),
      );
      final recordSnapshots =
          await cityNameStore.find(await _db, finder: finder);

      if (recordSnapshots.isEmpty) {
        throw Exception("No cities found matching the query.");
      }
      // Assuming you want only the first match
      final city = WeatherModel.fromJson(recordSnapshots.first.value);
      return Right(city);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// update city
  @override
  Future<Either<String, String>> updateCitiesWeather(
      WeatherModel weatherModel) {
    throw UnimplementedError();
  }

  Future<Either<String, List<WeatherModel>>> populateWeatherDatabase() async {
    try {
      final recordSnapshots = await cityNameStore.find(await _db);
      final weatherModels = recordSnapshots.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      return Left('Error fetching data: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, WeatherModel>> saveUserCurrentCity(
      WeatherModel weatherModel) async {
    try {
      final cityNameNormalized = normalizeCityName(weatherModel.name);
      final existingRecords = await cityNameStore.find(
        await _db,
        finder: Finder(
          filter: Filter.custom((record) {
            final recordNameNormalized =
                normalizeCityName(record['name'] as String);
            return recordNameNormalized == cityNameNormalized;
          }),
        ),
      );

      if (existingRecords.isNotEmpty) {
        final existingWeatherModel =
            WeatherModel.fromJson(existingRecords.first.value);
        return Right(existingWeatherModel);
      }

      await cityNameStore.add(await _db, weatherModel.toJson());
      return Right(weatherModel);
    } catch (e) {
      return Left('Insert failed2: ${e.toString()}');
    }
  }

  Future<String> getCityImage(String cityName) async {
    String url = WeatherAppServices.cityImageApi +
        cityName +
        WeatherAppServices.cityImageApiImage;
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        if (response.data.containsKey('photos') &&
            response.data['photos'].isNotEmpty) {
          var imageData = response.data['photos'][0]['image']['mobile'];

          return imageData; // Using Either
        } else {
          return ""; // No data found
        }
      } else {
        return 'Error: Unexpected response status code ${response.statusCode}';
      }
    } catch (e) {
      return "";
    }
  }
}
