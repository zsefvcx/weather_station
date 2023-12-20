
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_station/common/common.dart';
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
  static const String _baseUrl = 'https://api.openweathermap.org/';
  static const String _geo = 'geo/1.0/direct';
  static const String _data = 'data/2.5/weather';
  static const String _unit = '&units=metric';
  //stack data
  final StackDataOpenWeather stackDOW;
  //stack data for chart
  final StackChartDataValue stackCDV;
  //timeLimit - limit await udp response
  final Duration timeLimit;
  //periodic - frequency of requests
  final Duration periodic;
  // chaker network Status
  final NetworkInfo networkInfo;

  const OpenWeatherClient({
    required this.stackDOW,
    required this.stackCDV,
    required this.networkInfo,
    this.timeLimit = Constants.timeLimitWD,
    this.periodic = Constants.periodicWD,
  });

  Uri _getUriGeoPosition() {
    //'https://api.openweathermap.org/geo/1.0/direct?'
    //'q=$sCity'
    //'&appid=$appid'
    final url =  '$_baseUrl$_geo?q=${Settings.sCity}&appid=${Settings.appid}';
    Logger.print('uriGeoPosition: $url');
    return Uri.parse(
      url
    );
  }

  Uri _getUriWeatherStatus({required double lat, required double lon}) {
    //'https://api.openweathermap.org/data/2.5/weather?'
    //         'lat=$lat'
    //         '&lon=$lon'
    //         '&units=metric'
    //         '&appid=$appid'
    final url = '$_baseUrl$_data?lat=${Settings.lat}&lon=${Settings.lon}$_unit&appid=${Settings.appid}';
    Logger.print('uriWeatherStatus: $url');
    return Uri.parse(
      url
    );
  }

  Future<({double lat, double lon})> _getPosition({required Uri uri}) async {
    try {
      var lat = Settings.lat;
      var lon = Settings.lon;
      if(Settings.gettingPosition)return (lat: lat, lon: lon);
      final response = await http.get(uri);
      Logger.print('Response status: ${response.statusCode}');
      if (response.statusCode == 200){
        final jsonList0 = (jsonDecode(response.body) as List<dynamic>?)?[0];
        if(jsonList0 != null){
          final jsonMap = jsonList0 as Map<String, dynamic>;
          Logger.print('Response body_json: $jsonMap');
          lat = (jsonMap['lat'] as double?)??lat;
          lon = (jsonMap['lon'] as double?)??lon;
          Settings.gettingPosition = true;
          Settings.lat = lat;
          Settings.lon = lon;
          return (lat: lat, lon: lon);
        }
        throw OpenWeatherClientException(
          errorMessageText: 'Wrong getPosition response date: ${response.statusCode}'
        );
      }
      throw OpenWeatherClientException(
        errorMessageText: 'Wrong getPosition status code: ${response.statusCode}'
      );
    } on Exception catch(e, t) {
      throw OpenWeatherClientException(
          errorMessageText: 'Error getPosition OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  Future<Map<String, dynamic>> _getWeather({required Uri uri}) async {
    try {
      final response = await http.get(uri);
      Logger.print('Response status: ${response.statusCode}');
      if (response.statusCode == 200){
        final jsonList0 = jsonDecode(response.body) as Map<String, dynamic>?;
        if(jsonList0 != null){
          return jsonList0;
        }
        throw OpenWeatherClientException(
            errorMessageText: 'Wrong getWeather response date: ${response.statusCode}'
        );
      }
      throw OpenWeatherClientException(
            errorMessageText: 'Wrong getWeather status code: ${response.statusCode}'
      );
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
        return;
      }
      final uriGeo = _getUriGeoPosition();
      Logger.print('uriGeo.path: ${uriGeo.path}');
      final position = await _getPosition(uri: uriGeo);
      Logger.print('position{Lat:${position.lat},Lon:${position.lon}}');
      final uriWeather = _getUriWeatherStatus(
          lat:position.lat,
          lon:position.lon
      );
      Logger.print('uriWeather.path: ${uriWeather.path}');
      final weatherJson = await _getWeather(uri: uriWeather);
      Logger.print('Weather: $weatherJson');
      final weatherDate = WeatherDate.fromJson(weatherJson);
      Logger.print('weatherDate: ${weatherDate.toJson()}');
      stackDOW.add(weatherDate);
      final dataChart = ChartDataValue.fromWeatherDate(
          weatherDate,
          time: DateTime.now(),
      );
      Logger.print(dataChart.toString());
      stackCDV.add(dataChart);
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
    } on OpenWeatherClientException catch(e){
      Logger.print(e.errorMessageText);
      throw OpenWeatherClientException(
          errorMessageText: e.errorMessageText
      );
    } on Exception catch(e, t) {
      throw OpenWeatherClientException(
          errorMessageText: 'Error run OpenWeatherClient with:\n$e\n$t'
      );
    }
  }
}
