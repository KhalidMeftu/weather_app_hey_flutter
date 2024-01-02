import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';
import 'package:flutterweatherapp/presentation/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';

part 'user_city_controller_event.dart';
part 'user_city_controller_state.dart';

class UserCityControllerBloc extends Bloc<UserCityControllerEvent, UserCityControllerState> {
  final WeatherAppUseCases getMedaUseCase;

  UserCityControllerBloc(this.getMedaUseCase) : super(UserCityControllerInitial()) {
    on<SaveUserCity>((event, emit) async {
      // TODO: implement event handler
      emit(const UserActionLoading());
      final result=await getMedaUseCase.saveUserCity(event.weatherModel);
      result.fold((left) => emit(UserCityAction(left)),
              (right) => emit(UserCitySaveSuccessfull(right)));
    });

    on<DeleteUserCity>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateUserCity>((event, emit) {
      // TODO: implement event handler
    });

    /// fetch user city
    on<FetchUserCity>((event, emit) async {
      // TODO: implement event handler
      emit(const UserActionLoading());
      final result=await getMedaUseCase.loadUserCity();
      result.fold((left) => emit(UserCityAction(left)),
              (right) => emit(UserCityLoaded(right)));
    });

    // search
    on<SearchUserCity>((event, emit) async {
      // TODO: implement event handler
      emit(const UserActionLoading());
      final result=await getMedaUseCase.searchCity(event.cityName);

      result.fold((left) => emit(UserCityAction(left)),
              (right) => emit(SearchUserCityLoaded(right)));
    });


    /// save current city
    on<SaveCurrentCity>((event, emit) async {
      // TODO: implement event handler
      emit(const UserActionLoading());
      final result=await getMedaUseCase.saveUserCurrentCity(event.weatherModel);
      result.fold((left) => emit(CurrentCitySavingResponse(left)),
              (right) => emit(CurrentCitySaveSuccessfull(right)));
    });
  }
}
