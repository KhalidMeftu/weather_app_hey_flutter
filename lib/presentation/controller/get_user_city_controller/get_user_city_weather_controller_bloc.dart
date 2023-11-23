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
      final result=await getMedaUseCase.getUserCityWeather(event.cityName);
      result.fold((left) => emit(UserCityWeatherLoadingError(left)),
              (right) => emit(UserCityWeatherLoaded(right)));

    });
  }
}
