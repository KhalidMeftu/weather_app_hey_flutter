part of 'home_controller_bloc.dart';

abstract class HomeControllerEvent extends Equatable {
  const HomeControllerEvent();
}
/// save current city

class SaveCurrentCityWeather extends HomeControllerEvent{
  final WeatherModel weatherModel;

  const SaveCurrentCityWeather(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];
}
/// get current city data
class GetCurrentCityWeatherInfo extends HomeControllerEvent{
  final String currentCityName;

  const GetCurrentCityWeatherInfo(this.currentCityName);

  @override
  // TODO: implement props
  List<Object?> get props => [currentCityName];
}

// get daily forecast

class GetHomeDailyForCast extends HomeControllerEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}