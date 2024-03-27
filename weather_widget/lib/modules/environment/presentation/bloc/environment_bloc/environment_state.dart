part of 'environment_bloc.dart';

@freezed
class EnvironmentState with _$EnvironmentState {
  const factory EnvironmentState.loading() = _loadingState;
  const factory EnvironmentState.stop({
    EnvironmentDataEntity? cacheData,
  }) = _stopState;
  const factory EnvironmentState.loaded({
    required EnvironmentDataEntity data,
    required TypeData type,
  }) = _loadedState;
  const factory EnvironmentState.error({
    required String massage,
    EnvironmentDataEntity? cacheData,
  }) = _errorState;
}
