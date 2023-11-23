part of 'get_city_image_controller_bloc.dart';

abstract class GetCityImageControllerEvent extends Equatable {
  const GetCityImageControllerEvent();
}

class GetCityPhoto extends GetCityImageControllerEvent{
  final String cityName;

  const GetCityPhoto(this.cityName);
  @override
  // TODO: implement props
  List<Object?> get props => [cityName];

}