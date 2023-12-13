import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/weather_station_app.dart';

Future<void> main() async {

  final stackDEC = StackDataEnvironmentalConditions();
  final internetConnectionChecker = InternetConnectionChecker();
  final networkInfo = NetworkInfoImp(
    internetConnectionChecker: internetConnectionChecker
  );

  final udpMultyCastReceiver = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    type: TypeDataRcv.multy,
    networkInfo: networkInfo,
  );
  await udpMultyCastReceiver.run();
  final udpClient = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    type: TypeDataRcv.syngl,
    networkInfo: networkInfo,
    address: '192.168.100.12',
    bindPort: 0,
  );
  await udpClient.run(broadcastEnabled: false);

  //final timer = await udpClientSenderReceiver.run();
  //timer.cancel();

  final openWeatherClient = OpenWeatherClient(
    networkInfo: networkInfo
  );
  await openWeatherClient.run();




  Future<void> getDataOpenWeatherMap() async{
    final sCity = Settings.sCity;
    //String city_id = '572525';
    final appid = Settings.appid;
    var lat = Settings.lat;
    var lon = Settings.lon;
    try {
      final uri1 = Uri.parse('https://api.openweathermap.org/geo/1.0/direct?'
          'q=$sCity'
          '&appid=$appid');
      Logger.print(uri1.path);

      final response1 = await http.get(uri1);



      if (response1.statusCode == 200){
        final jsonList0 = (jsonDecode(response1.body) as List<dynamic>?)?[0];
        if(jsonList0 != null){
          final jsonMap = jsonList0 as Map<String, dynamic>;
          Logger.print('Response body_json: $jsonMap');
          lat = (jsonMap['lat'] as double?)??lat;
          lon = (jsonMap['lon'] as double?)??lon;
        }
      }
      final uri2 = Uri.parse('https://api.openweathermap.org/data/2.5/weather?'
          'lat=$lat'
          '&lon=$lon'
          '&units=metric'
          '&appid=$appid');
      Logger.print(uri2.path);

      final response2 = await http.get(uri2);

      Logger.print('Response status: ${response2.statusCode}');

      if (response2.statusCode == 200){
        final json2 = jsonDecode(response2.body) as Map<String, dynamic>?;
        Logger.print('Response body_json: $json2');
      }
    } on Exception catch(e,t){
      Logger.print('Exception (weather): \n$e\n$t');
    }
  }

  await getDataOpenWeatherMap();
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    await getDataOpenWeatherMap();
  });




  runApp(WeatherAppStation(stackDEC: stackDEC,));
}
