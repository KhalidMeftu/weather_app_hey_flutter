part of 'get_user_city_weather_controller_bloc.dart';

abstract class GetUserCityWeatherControllerState extends Equatable {
  const GetUserCityWeatherControllerState();
}

class GetUserCityWeatherControllerInitial extends GetUserCityWeatherControllerState {
  @override
  List<Object> get props => [];
}


/// show spiner on this state
class UserCityWeatherLoading extends GetUserCityWeatherControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// data is loaded show data
class UserCityWeatherLoaded extends GetUserCityWeatherControllerState{
  final WeatherModel cityWeatherInformation;
  final String cityImageURL;

  const UserCityWeatherLoaded(this.cityWeatherInformation, this.cityImageURL);
  @override
  // TODO: implement props
  List<Object?> get props => [cityWeatherInformation, cityImageURL];

}

/// data loading error
class UserCityWeatherLoadingError extends GetUserCityWeatherControllerState{
  final String errorMessage;
  const UserCityWeatherLoadingError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];

}