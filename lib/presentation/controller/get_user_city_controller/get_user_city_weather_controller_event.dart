part of 'get_user_city_weather_controller_bloc.dart';

abstract class GetUserCityWeatherControllerEvent extends Equatable {
  const GetUserCityWeatherControllerEvent();
}

class GetUserCityWeather extends GetUserCityWeatherControllerEvent {
  final String cityName;
  const GetUserCityWeather(this.cityName);
  @override
  // TODO: implement props
  List<Object?> get props => [cityName];
}

class GetSavedCityWeather extends GetUserCityWeatherControllerEvent {
   final String cityName;
  const GetSavedCityWeather(this.cityName);
  @override
  // TODO: implement props
  List<Object?> get props => [cityName];

}
