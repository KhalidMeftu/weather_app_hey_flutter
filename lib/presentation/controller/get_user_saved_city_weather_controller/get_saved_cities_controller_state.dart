part of 'get_saved_cities_controller_bloc.dart';

abstract class GetSavedCitiesControllerState extends Equatable {
  const GetSavedCitiesControllerState();
}

class GetSavedCitiesControllerInitial extends GetSavedCitiesControllerState {
  @override
  List<Object> get props => [];
}


/// show spinner on this state
class UserSavedCityWeatherLoading extends GetSavedCitiesControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// data is loaded show data
class UserSavedCityWeatherLoaded extends GetSavedCitiesControllerState{
  final WeatherModel cityWeatherInformation;

  const UserSavedCityWeatherLoaded(this.cityWeatherInformation);
  @override
  // TODO: implement props
  List<Object?> get props => [cityWeatherInformation];

}

/// data loading error
class UserSavedCityWeatherLoadingError extends GetSavedCitiesControllerState{
  final String errorMessage;
  const UserSavedCityWeatherLoadingError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];

}