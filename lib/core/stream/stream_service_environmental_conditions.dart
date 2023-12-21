
import 'dart:async';

import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StreamServiceEnvironmentalConditions{
  final _streamController = StreamController<EnvironmentalConditions?>.broadcast(
    onCancel: () => Logger.print('StreamController EnvironmentalConditions onCancel'),
    onListen: () => Logger.print('StreamController EnvironmentalConditions onListen'),
  );

  Stream<EnvironmentalConditions?> get stream => _streamController.stream;


  void add(EnvironmentalConditions? data){
    if (data!=null) _streamController.add(data);
  }

  void addStream(Stream<EnvironmentalConditions?> stream){
    _streamController.addStream(stream);
  }

  void dispose(){
    _streamController.close();
  }
}
