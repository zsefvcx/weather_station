//
// import 'dart:async';
//
// import 'package:weather_station/common/common.dart';
// import 'package:weather_station/core/core.dart';
//
// class StreamServiceWeatherData {
//   final _streamController = StreamController<WeatherData?>.broadcast(
//     onCancel: () => Logger.print('StreamController WeatherData onCancel'),
//     onListen: () => Logger.print('StreamController WeatherData onListen'),
//   );
//
//   Stream<WeatherData?> get stream => _streamController.stream;
//
//   void add(WeatherData? data){
//     if (data!=null) _streamController.add(data);
//   }
//
//   void addStream(Stream<WeatherData?> stream){
//     _streamController.addStream(stream);
//   }
//
//   void dispose(){
//     _streamController.close();
//   }
// }
