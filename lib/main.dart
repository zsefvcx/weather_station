import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/weather_station_app.dart';

void main() {

  final stackDEC = StackDataEnvironmentalConditions();
  final stackDOW  = StackDataOpenWeather();
  final internetConnectionChecker = InternetConnectionChecker();

  final networkInfo = NetworkInfoImp(
    internetConnectionChecker: internetConnectionChecker
  );

  final udpMultyCastReceiver = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    type: TypeDataRcv.multy,
    networkInfo: networkInfo,
  );
  unawaited(udpMultyCastReceiver.run());
  //final timer = await udpClientSenderReceiver.run();
  //timer.cancel();

  final udpClient = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    type: TypeDataRcv.syngl,
    networkInfo: networkInfo,
    address: '192.168.100.12',
    bindPort: 0,
  );
  unawaited(udpClient.run(broadcastEnabled: false));
  //final timer = await udpClient.run();
  //timer.cancel();

  final openWeatherClient = OpenWeatherClient(
    stackDOW: stackDOW,
    networkInfo: networkInfo
  );
  unawaited(openWeatherClient.run());
  //final timer = await openWeatherClient.run();
  //timer.cancel();

  runApp(WeatherAppStation(
    stackDEC: stackDEC,
    stackDOW: stackDOW,
  ));
}
