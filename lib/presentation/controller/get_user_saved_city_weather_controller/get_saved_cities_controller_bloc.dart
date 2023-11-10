import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';

part 'get_saved_cities_controller_event.dart';
part 'get_saved_cities_controller_state.dart';

class GetSavedCitiesControllerBloc extends Bloc<GetSavedCitiesControllerEvent, GetSavedCitiesControllerState> {
  GetSavedCitiesControllerBloc() : super(GetSavedCitiesControllerInitial()) {
    on<GetSavedCitiesWeather>((event, emit) {
      // TODO: implement event handler
    });
  }
}
