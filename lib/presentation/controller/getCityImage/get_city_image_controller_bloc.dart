import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'get_city_image_controller_event.dart';
part 'get_city_image_controller_state.dart';

class GetCityImageControllerBloc extends Bloc<GetCityImageControllerEvent, GetCityImageControllerState> {
  final WeatherAppUseCases getMedaUseCase;

  GetCityImageControllerBloc(this.getMedaUseCase) : super(GetCityImageControllerInitial()) {
    on<GetCityPhoto>((event, emit) async {
      emit(CityImageLoading());

      final result=await getMedaUseCase.getCityImage(event.cityName);
      result.fold((left) => emit(CityImageLoadingError(left)),
              (right) => emit(CityImageWeatherLoaded(right)));
    });


  }
}
