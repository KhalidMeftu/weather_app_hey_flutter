part of 'get_city_image_controller_bloc.dart';

abstract class GetCityImageControllerState extends Equatable {
  const GetCityImageControllerState();
}

class GetCityImageControllerInitial extends GetCityImageControllerState {
  @override
  List<Object> get props => [];
}

/// show spinner on this state
class CityImageLoading extends GetCityImageControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// show spinner on this state
class CityImageLoadingLDB extends GetCityImageControllerState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

/// data is loaded show data
class CityImageWeatherLoaded extends GetCityImageControllerState{
  final String imageURL;

  const CityImageWeatherLoaded(this.imageURL);
  @override
  // TODO: implement props
  List<Object?> get props => [imageURL];

}

/// data is loaded show data
class CityImageWeatherLoadedLDB extends GetCityImageControllerState{
  final String imageURL;

  const CityImageWeatherLoadedLDB(this.imageURL);
  @override
  // TODO: implement props
  List<Object?> get props => [imageURL];

}

/// data loading error
class CityImageLoadingError extends GetCityImageControllerState{
  final String errorMessage;
  const CityImageLoadingError(this.errorMessage);
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];

}