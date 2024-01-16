import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterweatherapp/domian/entity/weather_entity.dart';
import 'package:flutterweatherapp/domian/usecases/weatherapp_usecases.dart';

part 'sync_database_event.dart';

part 'sync_database_state.dart';

class SyncDatabaseBloc extends Bloc<SyncDatabaseEvent, SyncDatabaseState> {
  final WeatherAppUseCases getMedaUseCase;

  SyncDatabaseBloc(this.getMedaUseCase) : super(SyncDatabaseInitial()) {
    on<SyncMyData>((event, emit) async {
      emit(SyncingWeatherData());
      bool allDataSynced = true;
      for (int i = 0; i < event.cityNames.length; i++) {
        final result =
            await getMedaUseCase.syncUserCitiesData(event.cityNames[i].name, event.cityNames[i].isCurrentCity??false);
        result.fold(
          (left) {
            emit(DataSyncError(left));
            allDataSynced = false;
          },
          (right) {
            //emit(DataSyncSuccessfull(right));
            print("Data sync successfull");
            print(right.cityImageURL);
            allDataSynced = false;

          },
        );
      }

      if (allDataSynced) {
        emit(SyncSuccessfull());
      }
    });
  }
}