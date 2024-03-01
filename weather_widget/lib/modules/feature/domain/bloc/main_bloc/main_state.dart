part of 'main_bloc.dart';

@freezed
class MainBlocState with _$MainBlocState {
  const factory MainBlocState.loading() = _loadingState;
  const factory MainBlocState.loaded() = _loadedState;
  const factory MainBlocState.error() = _errorState;
  const factory MainBlocState.timeOut() = _timeOut;
}
