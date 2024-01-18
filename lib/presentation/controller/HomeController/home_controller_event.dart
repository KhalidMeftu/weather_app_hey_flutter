part of 'home_controller_bloc.dart';

abstract class HomeControllerEvent extends Equatable {
  const HomeControllerEvent();
}
class GetInitialEvent extends HomeControllerEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
/// get current city data
class GetCurrentCityWeatherInfo extends HomeControllerEvent{
  final String currentCityName;

  const GetCurrentCityWeatherInfo(this.currentCityName);

  @override
  // TODO: implement props
  List<Object?> get props => [currentCityName];
}

// get daily forecast

class GetHomeDailyForCast extends HomeControllerEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}