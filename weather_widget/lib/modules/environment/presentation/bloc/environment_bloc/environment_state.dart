part of 'environment_bloc.dart';

@freezed
class EnvironmentState with _$EnvironmentState {
  const factory EnvironmentState.loading() = _loadingState;
  const factory EnvironmentState.loaded({required EnvironmentDataEntity data}) = _loadedState;
  const factory EnvironmentState.error({required String massage}) = _errorState;
}
