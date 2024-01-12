part of 'sync_database_bloc.dart';

abstract class SyncDatabaseEvent extends Equatable {
  const SyncDatabaseEvent();
}


class SyncMyData extends SyncDatabaseEvent{
  final List<WeatherModel> cityNames;

  const SyncMyData(this.cityNames);
  @override
  // TODO: implement props
  List<Object?> get props => [cityNames];

}