part of 'main_bloc.dart';

@freezed
class MainBlocEvent with _$MainBlocEvent{
  const factory MainBlocEvent.init({
    required String uuid
  }) = _initEvent;
  const factory MainBlocEvent.read({
    required String uuid
  }) = _readEvent;
  const factory MainBlocEvent.write({
    required String uuid,
    required Completer<dynamic> completer,
  }) = _writeEvent;
  const factory MainBlocEvent.delete({
    required String uuid,
  }) = _deleteEvent;
}
