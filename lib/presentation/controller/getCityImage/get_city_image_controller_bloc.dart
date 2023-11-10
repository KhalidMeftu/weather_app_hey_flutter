import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_city_image_controller_event.dart';
part 'get_city_image_controller_state.dart';

class GetCityImageControllerBloc extends Bloc<GetCityImageControllerEvent, GetCityImageControllerState> {
  GetCityImageControllerBloc() : super(GetCityImageControllerInitial()) {
    on<GetCityImageControllerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
