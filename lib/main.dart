import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/weather_station_app.dart';

Future<void> main() async {
  final stackDEC = StackDataEnvironmentalConditions();

  //final stackCDV = StackChartDataValue();
  final internetConnectionChecker = InternetConnectionChecker();

  final networkInfo =
      NetworkInfoImp(internetConnectionChecker: internetConnectionChecker);

  // final odpMultiCastReceiver = UDPClientSenderReceiver(
  //   stackDEC: stackDEC,
  //   stackCDV: stackCDV,
  //   type: TypeDataRcv.multi,
  //   networkInfo: networkInfo,
  // );
  // unawaited(odpMultiCastReceiver.run());
  // //final timer = await udpClientSenderReceiver.run();
  // //timer.cancel();
  //
  // final udpClient = UDPClientSenderReceiver(
  //   stackDEC: stackDEC,
  //   stackCDV: stackCDV,
  //   type: TypeDataRcv.single,
  //   networkInfo: networkInfo,
  //   address: Settings.remoteAddress,
  //   bindPort: 0,
  // );
  // unawaited(udpClient.run(broadcastEnabled: false));
  // //final timer = await udpClient.run();
  // //timer.cancel();
  //
  // final udpClient2 = UDPClientSenderReceiver(
  //   stackDEC: stackDEC,
  //   stackCDV: stackCDV,
  //   type: TypeDataRcv.single,
  //   networkInfo: networkInfo,
  //   address: Settings.remoteAddress2,
  //   bindPort: 0,
  // );
  // unawaited(udpClient2.run(broadcastEnabled: false));
  //final timer = await udpClient.run();
  //timer.cancel();

  final openWeatherClient = OpenWeatherClient(
    networkInfo: networkInfo
  );

//  final streamWD = await streamController.addStream(openWeatherClient.run());

  final serviceWD = StreamServiceWeatherData()..addStream(openWeatherClient.run());

  final stackDOW = StackDataOpenWeather(serviceWD.stream)..listen;
  final stackCDV = StackChartDataValue(serviceWD.stream)..listen;



  final currentDateTime = CurrentDateTime()..run();

  runApp(WeatherAppStation(
    currentDateTime: currentDateTime,
    stackDEC: stackDEC,
    stackDOW: stackDOW,
    stackCDV: stackCDV,
  ));
}
