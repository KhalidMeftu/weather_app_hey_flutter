part of 'user_city_controller_bloc.dart';

abstract class UserCityControllerEvent extends Equatable {
  const UserCityControllerEvent();
}
/// insert
class InsertUserCity extends UserCityControllerEvent{
  final WeatherModel weatherModel;

  const InsertUserCity(this.weatherModel);

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