import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/weather_station_app.dart';

void main() {
  final stackDEC = StackDataEnvironmentalConditions();
  final stackDOW = StackDataOpenWeather();
  final stackCDV = StackChartDataValue();
  final internetConnectionChecker = InternetConnectionChecker();

  final networkInfo =
      NetworkInfoImp(internetConnectionChecker: internetConnectionChecker);

  final odpMultiCastReceiver = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    stackCDV: stackCDV,
    type: TypeDataRcv.multi,
    networkInfo: networkInfo,
  );
  unawaited(odpMultiCastReceiver.run());
  //final timer = await udpClientSenderReceiver.run();
  //timer.cancel();

  final udpClient = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    stackCDV: stackCDV,
    type: TypeDataRcv.single,
    networkInfo: networkInfo,
    address: Settings.remoutAddress,
    bindPort: 0,
  );
  unawaited(udpClient.run(broadcastEnabled: false));
  //final timer = await udpClient.run();
  //timer.cancel();

  final openWeatherClient = OpenWeatherClient(
    stackDOW: stackDOW,
    stackCDV: stackCDV,
    networkInfo: networkInfo
  );
  unawaited(openWeatherClient.run());
  //final timer = await openWeatherClient.run();
  //timer.cancel();

  final currentDateTime = CurrentDateTime()..run();

  runApp(WeatherAppStation(
    currentDateTime: currentDateTime,
    stackDEC: stackDEC,
    stackDOW: stackDOW,
    stackCDV: stackCDV,
  ));
}
