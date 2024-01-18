import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/services.dart';
import 'package:flutterweatherapp/const/app_extensions.dart';
import 'package:flutterweatherapp/const/app_resources.dart';
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
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    try {
      /// a 2-second delay to mock web response
      await Future.delayed(const Duration(seconds: 1));
      final String response =
          await rootBundle.loadString(WeatherAppResources.dailyForecastMock);
      final data = json.decode(response);

      if (data is Map<String, dynamic> &&
          data.containsKey(WeatherAppString.daily)) {
        final dailyData =
            List<Map<String, dynamic>>.from(data[WeatherAppString.daily]);
        List<Daily> dailyList =
            dailyData.map((json) => Daily.fromJson(json)).toList();
        return Right(dailyList);
      } else {
        return const Left(WeatherAppString.invalidJson);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherInfoForCurrentCity(
      String cityName) async {
    // TODO: implement getWeatherInfoForCurrentCity
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': WeatherAppServices.apiKey,
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
        return Left(WeatherAppString.weatherAppError +
            (response.statusCode).toString());
      }
    } catch (e, s) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return Left(
              WeatherAppString.weatherAppError + WeatherAppString.notFound);
        } else {
          return Left(
              '${WeatherAppString.weatherAppError}${e.response?.data['message'] ?? e.message}');
        }
      } else {
        return Left(WeatherAppString.weatherAppError +
            WeatherAppString.unExpectedError);
      }
    }
  }

  @override
  Future<Either<String, WeatherModel>> saveCurrentCityWeatherData(
      WeatherModel weatherModel) async {
    // TODO: implement saveCurrentCityWeatherData
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
      return Left('${WeatherAppString.dataInsertionFailed}${e.toString()}');
    }
  }

  String normalizeCityName(String name) {
    return name.toLowerCase().trim();
  }

  /// unslplash city images
  Future<String> getCityImage(String cityName) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${WeatherAppServices.unSplashBaseURL}?query=$cityName&client_id=${WeatherAppServices.unSplashApiKey}',
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['results'] != null &&
            responseData['results'].isNotEmpty) {
          var firstImage = responseData['results'][0];
          String imageUrl = firstImage['urls']['regular'];
          return imageUrl;
        } else {
          return "";
        }
      } else if (response.statusCode == 404) {
        return "";
      } else {
        return "";
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return "";
      } else {
        return "";
      }
    }
  }

  @override
  Future<Either<String, List<WeatherModel>>> saveUserCityData(
      WeatherModel weatherModel) async {
    // TODO: implement saveUserCityData

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
        // Update now we will do updates
        final existingRecord = existingRecords.first;
        await cityNameStore.update(
          await _db,
          weatherModel.toJson(),
          finder: Finder(
            filter: Filter.byKey(existingRecord.key),
          ),
        );

        final allRecords = await cityNameStore.find(await _db);
        final weatherModels = allRecords.map((snapshot) {
          return WeatherModel.fromJson(snapshot.value);
        }).toList();

        return Right(weatherModels);
      }
      await cityNameStore.add(await _db, weatherModel.toJson());
      final allRecords = await cityNameStore.find(await _db);
      final weatherModels = allRecords.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      return Left('${WeatherAppString.dataInsertionFailed}${e.toString()}');
    }
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(
      String cityName) async {
    // TODO: implement getWeatherForUserCity
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': WeatherAppServices.apiKey,
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
            '${WeatherAppString.unExpectedStatusCode} ${response.statusCode}');
      }
    } catch (e, s) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return const Left(WeatherAppString.notFound);
        } else {
          return Left(
              '${WeatherAppString.weatherAppError} ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        return const Left(WeatherAppString.unExpectedError);
      }
    }
  }

  @override
  Future<Either<String, List<WeatherModel>>> getUserCitiesWithWeather() async {
    return await populateWeatherDatabase();
  }

  Future<Either<String, List<WeatherModel>>> populateWeatherDatabase() async {
    try {
      final recordSnapshots = await cityNameStore.find(await _db);
      final weatherModels = recordSnapshots.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      return Left('${WeatherAppString.weatherAppError} ${e.toString()}');
    }
  }

  @override
  Future<Either<String, WeatherModel>> syncCitiesWeather(
      String cityName, bool isCurrentCity) async {
    // TODO: implement syncCitiesWeather
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': WeatherAppServices.apiKey,
    };
    try {
      Response response = await Dio()
          .get(WeatherAppServices.baseURL, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = WeatherModel.fromJson(response.data);
        final cityImage = await getCityImage(cityName);
        data.cityImageURL = cityImage;
        updateCurrentCityWeatherData(data);
        return Right(data);
      } else {
        return Left(
            'Error: Server responded with status code ${response.statusCode}');
      }
    } catch (e, s) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return const Left(WeatherAppString.notFound);
        } else {
          return Left(
              '${WeatherAppString.weatherAppError} ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        return const Left(WeatherAppString.unExpectedError);
      }
    }
  }

  /// update data
  ///
  Future<Either<String, WeatherModel>> updateCurrentCityWeatherData(
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

        // Update the existing record with the new data
        await cityNameStore.update(
          await _db,
          weatherModel.toJson(),
          finder: Finder(
            filter: Filter.custom((record) {
              final recordNameNormalized =
                  normalizeCityName(record['name'] as String);
              return recordNameNormalized == cityNameNormalized;
            }),
          ),
        );

        return Right(existingWeatherModel); // Return the existing weather model
      }

      await cityNameStore.add(await _db, weatherModel.toJson());
      return Right(weatherModel);
    } catch (e) {
      return Left('${WeatherAppString.dataInsertionFailed} ${e.toString()}');
    }
  }

  /// get current city Data

  @override
  Future<Either<String, WeatherModel>> getCurrentCityWeather() async {
    try {
      final recordSnapshots = await cityNameStore.find(await _db);

      if (recordSnapshots.isEmpty) {
        return Left(WeatherAppString.noData);
      }

      final recordSnapshot = recordSnapshots.first;
      final weatherModel = WeatherModel.fromJson(recordSnapshot.value);
      weatherModel.isCurrentCity = true;

      return Right(weatherModel);
    } catch (e) {
      return Left('${WeatherAppString.weatherAppError} ${e.toString()}');
    }
  }
}
