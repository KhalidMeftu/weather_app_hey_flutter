part of 'user_city_controller_bloc.dart';

abstract class UserCityControllerState extends Equatable {
  const UserCityControllerState();
}

class UserCityControllerInitial extends UserCityControllerState {
  @override
  List<Object> get props => [];
}

/// insert
class UserCitySaveSuccessfull extends UserCityControllerState{
  final List<WeatherModel> weatherModel;

  const UserCitySaveSuccessfull(this. weatherModel);
  @override
  // TODO: implement props
  List<Object?> get props => [ weatherModel];

}


/// insert current city
class CurrentCitySaveSuccessfull extends UserCityControllerState{
  final WeatherModel weatherModel;

  const CurrentCitySaveSuccessfull(this. weatherModel);
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
/// actions
class UserActionLoading extends UserCityControllerState{

  const UserActionLoading();
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

class CurrentCitySavingResponse extends UserCityControllerState{
  final String message;

  const CurrentCitySavingResponse(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}