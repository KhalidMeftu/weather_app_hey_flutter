import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internate_connectivity_event.dart';

part 'internate_connectivity_state.dart';

class InternateConnectivityBloc
    extends Bloc<InternateConnectivityEvent, InternateConnectivityState> {
  StreamSubscription? _subscription;

  InternateConnectivityBloc() : super(InternateConnectivityInitial()) {
    on<InternateConnectivityEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(const ConnectedState(message: "Connected"));
      } else if (event is NotConnectedEvent) {
        emit(const NotConnectedState(message: "Not Connected"));
      }
    });
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        add(ConnectedEvent());
      } else {
        add(NotConnectedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}
