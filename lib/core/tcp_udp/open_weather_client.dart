
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_station/core/core.dart';

class OpenWeatherClientException implements Exception {
  final String errorMessageText;

  const OpenWeatherClientException({
    required this.errorMessageText,
  });

  String errorMessage() {
    return 'Open Weather Client Exception: $errorMessageText';
  }
}

class OpenWeatherClient {

  final String _baseUrl = 'https://api.openweathermap.org/';
  final String _geo = 'geo/1.0/direct';
  final String _data = 'data/2.5/weather';
  final String _unit = '&units=metric';
  //timeLimit - limit await udp response
  final Duration timeLimit;
  //periodic - frequency of requests
  final Duration periodic;
  // chaker network Status
  final NetworkInfo networkInfo;

  const OpenWeatherClient({
    required this.networkInfo,
    this.timeLimit = Settings.timeLimit,
    this.periodic = Settings.periodic,
  });

  Uri get uriGeoPosition => Uri.parse(
      '$_baseUrl$_geo?q${Settings.sCity}&appid${Settings.appid}'
  );

  Uri get uriWeatherStatus => Uri.parse(
      '$_baseUrl$_data?lat${Settings.lat}&lon${Settings.lon}$_unit&appid${Settings.appid}'
  );

  Future<({double lat, double lon})> _getPosition() async {
    try {
      var lat = Settings.lat;
      var lon = Settings.lon;
      final uri = uriGeoPosition;
      final response = await http.get(uri);
      Logger.print('Response status: ${response.statusCode}');
      if (response.statusCode == 200){
        final jsonList0 = (jsonDecode(response.body) as List<dynamic>?)?[0];
        if(jsonList0 != null){
          final jsonMap = jsonList0 as Map<String, dynamic>;
          Logger.print('Response body_json: $jsonMap');
          lat = (jsonMap['lat'] as double?)??lat;
          lon = (jsonMap['lon'] as double?)??lon;
        }
      }
      return ({lat: lat, lon: lon});
    } on Exception catch(e, t) {
      throw OpenWeatherClientException(
          errorMessageText: 'Error getPosition OpenWeatherClient with:\n$e\n$t'
      );
    }
  }


  Future<void> _startRcvWeather() async {
    try {
      if(!(await networkInfo.isConnected)) {
        Logger.print('${DateTime.now()}:WeatherClient: No Network Info Status');
      }



    } on Exception catch(e, t) {
      throw OpenWeatherClientException(
          errorMessageText: 'Error getPosition OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  Future<Timer> run() async {
    try {
      await _startRcvWeather();
      return Timer.periodic(periodic, (timer) async =>
          _startRcvWeather(),
      );
    } on Exception catch(e, t) {
      throw OpenWeatherClientException(
          errorMessageText: 'Error run OpenWeatherClient with:\n$e\n$t'
      );
    }
  }
}
