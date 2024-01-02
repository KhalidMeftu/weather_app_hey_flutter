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
  //final String cityImageURL;

  const UserCityWeatherLoaded(this.cityWeatherInformation);
  @override
  // TODO: implement props
  List<Object?> get props => [cityWeatherInformation];

}
/// new user city loaded

class NewUserCityWeatherLoaded extends GetUserCityWeatherControllerState{
  final WeatherModel cityWeatherInformation;
  final String cityImageURL;

  const NewUserCityWeatherLoaded(this.cityWeatherInformation, this.cityImageURL);
  @override
  List<Object?> get props => [cityWeatherInformation, cityImageURL];

}

///splash screen
class UserCityWeatherLoadedSplashScreen extends GetUserCityWeatherControllerState{
  final WeatherModel cityWeatherInformation;
  final String cityImageURL;

  const UserCityWeatherLoadedSplashScreen(this.cityWeatherInformation, this.cityImageURL);
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