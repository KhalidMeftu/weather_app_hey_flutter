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
  final cityName = intMapStoreFactory.store(CityName);

  // Constructor
  RemoteDataSource() : _appDatabase = GetIt.instance<AppDatabase>();

  // Access the database
  Future<Database> get _db async => await _appDatabase.database;


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

  @override
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    try {
      /// a 2-second delay to mock web response
      await Future.delayed(const Duration(seconds: 2));
      final String response = await rootBundle.loadString('assets/json/mockdailyforecast.json');
      final data = json.decode(response);

      if (data is Map<String, dynamic> && data.containsKey('daily')) {
        final dailyData = List<Map<String, dynamic>>.from(data['daily']);
        List<Daily> dailyList = dailyData.map((json) => Daily.fromJson(json)).toList();
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
    try {
      final recordSnapshots = await cityName.find(await _db);
      final weatherModels = recordSnapshots.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      // If an error occurs, return Left with the error message
      return Left('Error fetching data: ${e.toString()}');
    }
  }


  /// insert ops
  @override
  Future<Either<String, String>> insertWeatherModel(WeatherModel weatherModel) async {
    try {
      // Check if the cityName already exists in the database
      final existingRecords = await cityName.find(
        await _db,
        finder: Finder(filter: Filter.equals('name', weatherModel.name)),
      );

      // If cityName already exists, don't insert and return a message
      if (existingRecords.isNotEmpty) {
        return const Left('Insert failed: cityName already exists');
      }

      // If cityName does not exist, proceed with the insert
      await cityName.add(await _db, weatherModel.toJson());
      return const Right('Insert successful');
    } catch (e) {
      // Handle specific exceptions if necessary
      return Left('Insert failed: ${e.toString()}');
    }
  }



  /// search
  @override
  Future<Either<String,List<WeatherModel>>> searchCities(String query) {
    // TODO: implement searchCities
    throw UnimplementedError();
  }

  /// update city
  @override
  Future<Either<String, String>> updateCitiesWeather(WeatherModel weatherModel) {
    throw UnimplementedError();
  }




}
