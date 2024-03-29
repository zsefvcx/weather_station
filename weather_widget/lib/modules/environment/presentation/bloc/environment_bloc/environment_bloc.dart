import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';

part 'environment_bloc.freezed.dart';
part 'environment_event.dart';
part 'environment_state.dart';

class EnvironmentBloc extends Bloc<EnvironmentEvent, EnvironmentState> {
  final ReceiveDataEnvironment receiveData;

  static int timeOutV = 10;

  ///Кеш в оперативной памяти
  EnvironmentDataEntity? cachedData;

  bool _status = false;
  bool get status => _status;

  EnvironmentBloc({
    required this.receiveData,
  }) : super(const EnvironmentState.loading()) {
    on<EnvironmentEvent>((event, emit) async {
      await event.map<FutureOr<void>>(
        startGet: (value) async {
          if(_status) return;
          final failure = receiveData.start();
          if (failure != null) {
            emit(EnvironmentState.error(
                massage: _mapFailureToMassage(failure)));
            _status = false;
            return;
          }
          _status = true;
        },
        stopGet: (value) async {
          if(!_status) return;
          final failure = receiveData.stop();
          if (failure != null) {
            emit(EnvironmentState.error(
                massage: _mapFailureToMassage(failure)));
            _status = false;
            return;
          }
          emit(EnvironmentState.stop(
            cacheData: cachedData
          ));
          _status = false;
        },
        receiveData: (value) async {
          emit(const EnvironmentState.loading());
          final stream = receiveData();
          await emit.forEach(stream, onData: (event) {
            final failure = event.$1;
            final type = event.$2;
            final data = event.$3;
            cachedData = data;
            if (failure != null) {
              return EnvironmentState.error(
                cacheData: data,
                massage: _mapFailureToMassage(failure),
              );
            } else if (data != null) {
              return EnvironmentState.loaded(
                data: data,
                type: type,
              );
            } else {
              return EnvironmentState.error(
                cacheData: data,
                massage: Constants.unexpectedErrorMessage,
              );
            }
          });
        },
      );
    });
  }

  String _mapFailureToMassage(Failure failure) {
    switch (failure) {
      case final ServerFailure sf:
        return '${Constants.serverFailureMessage}: ${sf.errorMessage}';
      case final CacheFailure sf:
        return '${Constants.cacheFailureMessage}: ${sf.errorMessage}';
      case final TimeOutFailure sf:
        return '${Constants.timeOutFailureMessage}: ${sf.errorMessage}';
      default:
        return Constants.unexpectedErrorMessage;
    }
  }
}
