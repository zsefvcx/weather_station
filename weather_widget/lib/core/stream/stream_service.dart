import 'dart:async';
import 'dart:developer' as dev;

import 'package:weather_widget/modules/environment/src.dart';

abstract class StreamService<T> {
  final _streamController = StreamController<T?>.broadcast(
    onCancel: () => dev.log('StreamController $T onCancel'),
    onListen: () => dev.log('StreamController $T onListen'),
  );

  Stream<T?> get stream => _streamController.stream;

  void add(T? data) {
    if (data != null) _streamController.add(data);
  }

  void addStream(Stream<T?> stream) {
    _streamController.addStream(stream);
  }

  void dispose() {
    _streamController.close();
  }
}

class EnvironmentStream extends StreamService<EnvironmentDataEntity> {}
