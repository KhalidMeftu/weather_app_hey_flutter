part of 'user_city_controller_bloc.dart';

abstract class UserCityControllerEvent extends Equatable {
  const UserCityControllerEvent();
}
/// insert
class SaveUserCity extends UserCityControllerEvent{
  final WeatherModel weatherModel;

  const SaveUserCity(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];

}

/// save current city

/// insert
class SaveCurrentCity extends UserCityControllerEvent{
  final WeatherModel weatherModel;

  const SaveCurrentCity(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];

}
/// delete

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
class FetchUserCity extends UserCityControllerEvent{

  const FetchUserCity();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// search
class SearchUserCity extends UserCityControllerEvent{
  final String cityName;

  const SearchUserCity(this.cityName);

  @override
  // TODO: implement props
  List<Object?> get props => [cityName];

}