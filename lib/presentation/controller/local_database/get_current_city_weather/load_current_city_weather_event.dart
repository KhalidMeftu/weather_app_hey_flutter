part of 'load_current_city_weather_bloc.dart';

abstract class LoadCurrentCityWeatherEvent extends Equatable {
  const LoadCurrentCityWeatherEvent();
}


class GetCurrentCityWeatherData extends LoadCurrentCityWeatherEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}