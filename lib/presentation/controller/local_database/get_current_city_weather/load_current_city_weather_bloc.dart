import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'load_current_city_weather_event.dart';
part 'load_current_city_weather_state.dart';

class LoadCurrentCityWeatherBloc extends Bloc<LoadCurrentCityWeatherEvent, LoadCurrentCityWeatherState> {
  final WeatherAppUseCases weatherAppUseCase;

  LoadCurrentCityWeatherBloc(this.weatherAppUseCase) : super(LoadCurrentCityWeatherInitial()) {
    on<GetCurrentCityWeatherData>((event, emit) async {
      // TODO: implement event handler

      emit(const CurrentCityWeatherLoading());
      final result = await weatherAppUseCase.getCurrentCityData();
      result.fold((left) => emit(CurrentCityWeatherLoadingError(left)),
              (right) => emit(CurrentCityWeatherLoaded(right)));
    });
  }
}
