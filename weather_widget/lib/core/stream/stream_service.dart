import 'dart:async';
import 'dart:developer' as dev;

import 'package:weather_widget/core/core.dart';

abstract class StreamService<T> {
  StreamController<T?>? _streamController;

  StreamController<T?> get _init => StreamController<T?>.broadcast(
        onCancel: () => dev.log('StreamController $T onCancel'),
        onListen: () => dev.log('StreamController $T onListen'),
      );

  StreamController<T?> get _initial => _streamController = _init;

  void initial(TypeDataRcv type) => _initial.onCancel = () {
    if (type != TypeDataRcv.single) {
      _streamController?.close();
      _streamController = null;
    }
  };

  Stream<T?> get stream =>
      (_streamController ?? _initial).stream;

  void add(T? data) {
    if (data != null) {
      (_streamController ?? _initial).add(data);
    }
  }

  void addStream(Stream<T?> stream) =>
      (_streamController ?? _initial).addStream(stream);

  void dispose() {
    _streamController?.close();
    _streamController = null;
  }
}

class EnvironmentStreamService extends StreamService<(Failure?, EnvironmentalConditions?)> {}
