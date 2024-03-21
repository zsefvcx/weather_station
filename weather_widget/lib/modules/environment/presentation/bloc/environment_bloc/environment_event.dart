part of 'environment_bloc.dart';

@freezed
class EnvironmentEvent with _$EnvironmentEvent{
  const factory EnvironmentEvent.startGet() = _startGetEvent;
  const factory EnvironmentEvent.stopGet() = _stopGetEvent;
  const factory EnvironmentEvent.receiveData() = _receiveDataEvent;
}
