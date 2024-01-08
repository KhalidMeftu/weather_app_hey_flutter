part of 'home_controller_bloc.dart';

abstract class HomeControllerState extends Equatable {
  const HomeControllerState();
}

class HomeControllerInitial extends HomeControllerState {
  @override
  List<Object> get props => [];
}

/// show spinner or shimmer
class SavingCurrentCity extends HomeControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// success return with saved city model
class CurrentCitySaved extends HomeControllerState{
  final WeatherModel currentCityData;
  const CurrentCitySaved(this.currentCityData);
  @override
  // TODO: implement props
  List<Object?> get props => [currentCityData];

}

/// saving error goto add page may be your city is not saved
class CurrentCitySavingError extends HomeControllerState{
  final String errorMessage;
  const CurrentCitySavingError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}

/// current city weather info loading
class CurrentCityWeatherInfoLoading extends HomeControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// get current city data
class CurrentCityDataLoaded extends HomeControllerState{
  final WeatherModel currentCityData;
  const  CurrentCityDataLoaded(this.currentCityData);
  @override
  // TODO: implement props
  List<Object?> get props => [currentCityData];

}

/// loading current city error
class CurrentCityWeatherInfoLoadingError extends HomeControllerState{
  final String errorMessage;
  const CurrentCityWeatherInfoLoadingError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}

/// forcast loading
class ForCastDataLoading extends HomeControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// forcast Loaded
class ForCastDataLoaded extends HomeControllerState{
  final List<Daily> forecastList;

  const ForCastDataLoaded(this.forecastList);
  @override
  // TODO: implement props
  List<Object?> get props => [forecastList];

}

///loading forcast error
class ForCastDataLoadingError extends HomeControllerState{
  final String errorMessage;

  const ForCastDataLoadingError(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}
