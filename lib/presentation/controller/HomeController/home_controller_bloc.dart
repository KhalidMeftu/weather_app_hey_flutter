import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'home_controller_event.dart';
part 'home_controller_state.dart';

class HomeControllerBloc extends Bloc<HomeControllerEvent, HomeControllerState> {
  final WeatherAppUseCases weatherAppUseCase;

  HomeControllerBloc(this.weatherAppUseCase) : super(HomeControllerInitial()) {

//
    on<GetInitialEvent>((event, emit) async {
      emit(HomeControllerInitial());

    });

    on<GetCurrentCityWeatherInfo>((event, emit) async {
      emit(CurrentCityWeatherInfoLoading());
      final result=await weatherAppUseCase.getCurrentCityWeather(event.currentCityName);
      result.fold((left) => emit(CurrentCityWeatherInfoLoadingError(left)),
              (right) => emit(CurrentCityDataLoaded(right)));
    });

    on<GetHomeDailyForCast>((event, emit) async {
      emit(ForCastDataLoading());
      final result=await weatherAppUseCase.getDailyForecast();
      result.fold((left) => emit(ForCastDataLoadingError(left)),
              (right) => emit(ForCastDataLoaded(right)));
    });
  }
}
