import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

part 'get_user_city_weather_controller_event.dart';
part 'get_user_city_weather_controller_state.dart';

class GetUserCityWeatherControllerBloc extends Bloc<GetUserCityWeatherControllerEvent, GetUserCityWeatherControllerState> {
  GetUserCityWeatherControllerBloc() : super(GetUserCityWeatherControllerInitial()) {
    on<GetUserCityWeather>((event, emit) {
      // TODO: implement event handler
    });
  }
}
