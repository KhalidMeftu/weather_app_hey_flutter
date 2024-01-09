part of 'save_current_city_bloc.dart';

abstract class SaveCurrentCityEvent extends Equatable {
  const SaveCurrentCityEvent();
}

class SaveCurrentCityWeather extends SaveCurrentCityEvent{
  final WeatherModel weatherModel;

  const SaveCurrentCityWeather(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];
}