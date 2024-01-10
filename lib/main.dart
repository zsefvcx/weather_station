import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/weather_station_app.dart';

Future<void> main() async {


  final internetConnectionChecker = InternetConnectionChecker();

  final networkInfo =
      NetworkInfoImp(internetConnectionChecker: internetConnectionChecker);

  final openWeatherClient = OpenWeatherClient(
    networkInfo: networkInfo
  );

  final serviceEC = StreamServiceEnvironmentalConditions();
  final odpMultiCastReceiver = UDPClientSenderReceiver(
    serviceEC: serviceEC,
    type: TypeDataRcv.multi,
    networkInfo: networkInfo,
    periodic: Constants.timeLimitWD
  );
  unawaited(odpMultiCastReceiver.run());

  final udpClient = UDPClientSenderReceiver(
    serviceEC: serviceEC,
    type: TypeDataRcv.single,
    networkInfo: networkInfo,
    address: Settings.remoteAddress,
    bindPort: 0,
  );
  unawaited(udpClient.run(broadcastEnabled: false));

  final udpClient2 = UDPClientSenderReceiver(
    serviceEC: serviceEC,
    type: TypeDataRcv.single,
    networkInfo: networkInfo,
    address: Settings.remoteAddress2,
    bindPort: 0,
  );
  unawaited(udpClient2.run(broadcastEnabled: false));

  await openWeatherClient.initIsolate();
  final serviceWD = StreamServiceWeatherData()..addStream(openWeatherClient.run2());

  final stackDOW = StackDataOpenWeather(serviceWD.stream)..listen;
  final stackDEC = StackDataEnvironmentalConditions(serviceEC.stream)..listen;
  final stackCDV = StackChartDataValue(serviceWD.stream, serviceEC.stream)..listen;

  final currentDateTime = CurrentDateTime()..run();

  runApp(WeatherAppStation(
    currentDateTime: currentDateTime,
    networkInfo: networkInfo,
    stackDEC: stackDEC,
    stackDOW: stackDOW,
    stackCDV: stackCDV,
  ));
}
