import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'save_current_city_event.dart';
part 'save_current_city_state.dart';

class SaveCurrentCityBloc extends Bloc<SaveCurrentCityEvent, SaveCurrentCityState> {
  final WeatherAppUseCases weatherAppUseCase;

  SaveCurrentCityBloc(this.weatherAppUseCase) : super(SaveCurrentCityInitial()) {
    on<SaveCurrentCityWeather>((event, emit) async {
      final result=await weatherAppUseCase.saveCurrentCityWeather(event.weatherModel);
      result.fold((left) => emit(CurrentCitySavingError(left)),
              (right) => emit(CurrentCitySaved(right)));


    });
  }
}
