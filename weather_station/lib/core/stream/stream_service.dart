
import 'dart:async';

import 'package:weather_station/common/common.dart';

abstract class StreamService<T> {

  final _streamController = StreamController<T?>.broadcast(
    onCancel: () => Logger.print('StreamController $T onCancel'),
    onListen: () => Logger.print('StreamController $T onListen'),
  );

  Stream<T?> get stream => _streamController.stream;

  void add(T? data){
    if (data!=null) _streamController.add(data);
  }

  void addStream(Stream<T?> stream){
    _streamController.addStream(stream);
  }

  void dispose(){
    _streamController.close();
  }

}
