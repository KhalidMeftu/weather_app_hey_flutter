part of 'internate_connectivity_bloc.dart';

abstract class InternateConnectivityState extends Equatable {
  const InternateConnectivityState();
}

class InternateConnectivityInitial extends InternateConnectivityState {
  @override
  List<Object> get props => [];
}
class ConnectedState extends InternateConnectivityState {
  final String message;

  const ConnectedState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class NotConnectedState extends InternateConnectivityState {
  final String message;

  const NotConnectedState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}