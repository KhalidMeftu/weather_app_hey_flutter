import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'user_city_controller_event.dart';
part 'user_city_controller_state.dart';

class UserCityControllerBloc extends Bloc<UserCityControllerEvent, UserCityControllerState> {
  final WeatherAppUseCases getMedaUseCase;

  UserCityControllerBloc(this.getMedaUseCase) : super(UserCityControllerInitial()) {
    on<InsertUserCity>((event, emit) async {
      // TODO: implement event handler
      emit(const UserCityExecute());

      final result=await getMedaUseCase.saveUserCity(event.weatherModel);
      result.fold((left) => emit(UserCityAction(left)),
              (right) => emit(UserCityInsertSuccessfull(right)));
    });

    on<DeleteUserCity>((event, emit) {
      // TODO: implement event handler
    });

    on<UpdateUserCity>((event, emit) {
      // TODO: implement event handler
    });
  }
}
