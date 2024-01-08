import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterweatherapp/domian/entity/forcast_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'get_daily_forecast_event.dart';

part 'get_daily_forecast_state.dart';

class GetDailyForecastBloc
    extends Bloc<GetDailyForecastEvent, GetDailyForecastState> {
  final WeatherAppUseCases getMedaUseCase;

  GetDailyForecastBloc(this.getMedaUseCase) : super(GetDailyForecastInitial()) {
    on<GetDailyForCast>((event, emit) async {
      emit(LoadingDailyForecast());
      final result = await getMedaUseCase.getDailyForecast();
      result.fold((left) => emit(DailyForcastLoadingError(left)),
          (right) => emit(DailyForecastLoaded(right)));
    });
  }
}

