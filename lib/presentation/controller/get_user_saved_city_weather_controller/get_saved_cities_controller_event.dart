part of 'get_saved_cities_controller_bloc.dart';

abstract class GetSavedCitiesControllerEvent extends Equatable {
  const GetSavedCitiesControllerEvent();
}


class GetSavedCitiesWeather extends GetSavedCitiesControllerEvent{
  final List<String> cityNames;

  const GetSavedCitiesWeather(this.cityNames);

  @override
  // TODO: implement props
  List<Object?> get props => [cityNames];

}