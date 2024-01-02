import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'get_user_city_weather_controller_event.dart';
part 'get_user_city_weather_controller_state.dart';

class GetUserCityWeatherControllerBloc extends Bloc<GetUserCityWeatherControllerEvent, GetUserCityWeatherControllerState> {
  final WeatherAppUseCases getMedaUseCase;

  GetUserCityWeatherControllerBloc(this.getMedaUseCase) : super(GetUserCityWeatherControllerInitial()) {
    on<GetUserCityWeather>((event, emit) async {

      emit(UserCityWeatherLoading());


      try {
      //  final imageURLResult = await getMedaUseCase.getCityImage(event.cityName);
        final weatherResult = await getMedaUseCase.getUserCityWeather(event.cityName);

        weatherResult.fold(
                (leftWeatherError) {
              emit(UserCityWeatherLoadingError(leftWeatherError));
            },
                (rightWeather) {
              print("Model emitted with image");

              emit(UserCityWeatherLoaded(rightWeather));
            }
        );
      } catch (error) {
        emit(UserCityWeatherLoadingError(error.toString()));
      }




    });

    on<GetSavedCityWeather>((event, emit) async {

      emit(UserCityWeatherLoading());
      final imageURL = await getMedaUseCase.getCityImage(event.cityName);
      final result=await getMedaUseCase.getUserCityWeather(event.cityName);

      imageURL.fold(
            (lefts) {
          result.fold((left) => emit(UserCityWeatherLoadingError(left)),
                  (right) => emit(NewUserCityWeatherLoaded(right, "")));
        },
            (rights) {
          result.fold((left) => emit(UserCityWeatherLoadingError(left)),
                  (right) => emit(NewUserCityWeatherLoaded(right, rights)));
        },
      );



    });

  }
}
