part of 'user_city_controller_bloc.dart';

abstract class UserCityControllerEvent extends Equatable {
  const UserCityControllerEvent();
}

class UserCityInitial extends UserCityControllerEvent{

  const UserCityInitial();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}
/// insert
class SaveUserCity extends UserCityControllerEvent{
  final WeatherModel weatherModel;

  const SaveUserCity(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];

}


class DeleteUserCity extends UserCityControllerEvent{
  final WeatherModel weatherModel;

  const DeleteUserCity(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];

}
/// update

class UpdateUserCity extends UserCityControllerEvent{
  final WeatherModel weatherModel;

  const UpdateUserCity(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];

}

/// fetch all user data
class FetchSavedCitiesData extends UserCityControllerEvent{

  const FetchSavedCitiesData();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class GetCityWeather extends UserCityControllerEvent {
  final String cityName;
  final BuildContext context;
  final bool cityNotFound;
  const GetCityWeather(this.cityName, this.context, this.cityNotFound);
  @override
  // TODO: implement props
  List<Object?> get props => [cityName,context,cityNotFound];

}

