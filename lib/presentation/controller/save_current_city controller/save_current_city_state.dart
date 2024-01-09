part of 'save_current_city_bloc.dart';

abstract class SaveCurrentCityState extends Equatable {
  const SaveCurrentCityState();
}

class SaveCurrentCityInitial extends SaveCurrentCityState {
  @override
  List<Object> get props => [];
}
/// show spinner or shimmer
class SavingCurrentCity extends SaveCurrentCityState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// success return with saved city model
class CurrentCitySaved extends SaveCurrentCityState{
  final WeatherModel currentCityData;
  const CurrentCitySaved(this.currentCityData);
  @override
  // TODO: implement props
  List<Object?> get props => [currentCityData];

}

/// saving error goto add page may be your city is not saved
class CurrentCitySavingError extends SaveCurrentCityState{
  final String errorMessage;
  const CurrentCitySavingError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}