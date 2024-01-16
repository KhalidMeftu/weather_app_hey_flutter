part of 'load_current_city_weather_bloc.dart';

abstract class LoadCurrentCityWeatherState extends Equatable {
  const LoadCurrentCityWeatherState();
}

class LoadCurrentCityWeatherInitial extends LoadCurrentCityWeatherState {
  @override
  List<Object> get props => [];
}


class CurrentCityWeatherLoading extends LoadCurrentCityWeatherState{

  const CurrentCityWeatherLoading();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class CurrentCityWeatherLoaded extends LoadCurrentCityWeatherState{
  final WeatherModel weatherModel;

  const CurrentCityWeatherLoaded(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];

}

class CurrentCityWeatherLoadingError extends LoadCurrentCityWeatherState{
  final String message;

  const CurrentCityWeatherLoadingError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
