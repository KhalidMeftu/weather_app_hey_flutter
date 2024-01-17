part of 'sync_database_bloc.dart';

abstract class SyncDatabaseState extends Equatable {
  const SyncDatabaseState();
}

class SyncDatabaseInitial extends SyncDatabaseState {
  @override
  List<Object> get props => [];
}


class SyncingWeatherData extends SyncDatabaseState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class DataSyncSuccessfull extends SyncDatabaseState{
  final WeatherModel weatherModel;

  const DataSyncSuccessfull(this.weatherModel);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];
}


class SyncSuccessfull extends SyncDatabaseState{
final List<WeatherModel> newModel;

  const SyncSuccessfull(this.newModel);

  @override
  // TODO: implement props
  List<Object?> get props => [newModel];
}
class DataSyncError extends SyncDatabaseState{
  final String errorMessage;

  const DataSyncError(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];

}