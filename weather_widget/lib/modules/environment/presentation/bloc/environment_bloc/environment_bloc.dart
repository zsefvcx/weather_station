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

  EnvironmentDataEntity? data;
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
          emit(const EnvironmentState.stop());
          _status = false;
        },
        receiveData: (value) async {
          emit(const EnvironmentState.loading());
          final stream = receiveData();
          await emit.forEach(stream, onData: (event) {
            final failure = event.$1;
            final data = event.$2;
            if (failure != null) {
              return EnvironmentState.error(
                massage: _mapFailureToMassage(failure),
              );
            } else if (data != null) {
            this.data = data;
              return EnvironmentState.loaded(data: data);
            } else {
              return const EnvironmentState.error(
                massage: unexpectedErrorMessage,
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
        return '$serverFailureMessage: ${sf.errorMessage}';
      case final CacheFailure sf:
        return '$cacheFailureMessage: ${sf.errorMessage}';
      case final TimeOutFailure sf:
        return '$timeOutFailureMessage: ${sf.errorMessage}';
      default:
        return unexpectedErrorMessage;
    }
  }
}
