import 'package:flutter/material.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/weather_station_app.dart';

Future<void> main() async {

  final stackDEC = StackDataEnvironmentalConditions();
  final udpMultyCastReceiver = UDPClientSenderReceiver(
      stackDEC: stackDEC,
      type: TypeDataRcv.multy,
  );
  await udpMultyCastReceiver.run();
  final udpClient = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    type: TypeDataRcv.syngl,
    address: '192.168.100.12',
    bindPort: 0,
  );
  await udpClient.run(broadcastEnabled: false);

  //final timer = await udpClientSenderReceiver.run();
  //timer.cancel();

  runApp(WeatherAppStation(stackDEC: stackDEC,));
}
