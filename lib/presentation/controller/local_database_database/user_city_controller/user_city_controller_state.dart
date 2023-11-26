part of 'user_city_controller_bloc.dart';

abstract class UserCityControllerState extends Equatable {
  const UserCityControllerState();
}

class UserCityControllerInitial extends UserCityControllerState {
  @override
  List<Object> get props => [];
}

/// insert
class UserCityInsertSuccessfull extends UserCityControllerState{
  final List<WeatherModel> weatherModel;

  const UserCityInsertSuccessfull(this. weatherModel);
  @override
  // TODO: implement props
  List<Object?> get props => [ weatherModel];

}

/// delete
class UserCityDeleteSuccessfull extends UserCityControllerState{
  final String successMessage;

  const UserCityDeleteSuccessfull(this.successMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [successMessage];

}

/// update

class UserCityUpdateSuccessfull extends UserCityControllerState{
  final String successMessage;

  const UserCityUpdateSuccessfull(this.successMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [successMessage];

}

/// actions may be deleting inserting, updating
///
class UserCityAction extends UserCityControllerState{
  final String actionMessage;

  const UserCityAction(this.actionMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [actionMessage];

}
/// actions may be deleting inserting, updating loading
class UserCityExecute extends UserCityControllerState{

  const UserCityExecute();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// user city loaded
class UserCityLoaded extends UserCityControllerState{
final List<WeatherModel> usermodel;
  const UserCityLoaded(this.usermodel);
  @override
  // TODO: implement props
  List<Object?> get props => [usermodel];

}

///search results
class SearchUserCityLoaded extends UserCityControllerState{
  final WeatherModel usermodel;
  const SearchUserCityLoaded(this.usermodel);
  @override
  // TODO: implement props
  List<Object?> get props => [usermodel];

}