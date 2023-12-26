
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

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
  //timeLimit - limit await udp response
  final Duration timeLimit;
  //periodic - frequency of requests
  final Duration periodic;
  //Chacker network Status
  final NetworkInfo networkInfo;
  //StreamSubscription
  static StreamSubscription<dynamic>? streamSubscription;
  //Isolate
  static Isolate? isolate;
  //ReceivePort
  static ReceivePort receivePort = ReceivePort();

  const OpenWeatherClient({
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
               Logger.print('Wrong getPosition response date: ${response.body}', name: 'err',  error: true,  safeToDisk: true,);
        throw OpenWeatherClientException(
          errorMessageText: 'Wrong getPosition response date: ${response.body}'
        );
      }
             Logger.print('Wrong getPosition status code: ${response.statusCode}', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
        errorMessageText: 'Wrong getPosition status code: ${response.statusCode}'
      );
    } on Exception catch(e, t) {
               Logger.print('Error getPosition OpenWeatherClient with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
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
                 Logger.print('Wrong getWeather response date: ${response.statusCode}', name: 'err',  error: true,  safeToDisk: true,);
        throw OpenWeatherClientException(
            errorMessageText: 'Wrong getWeather response date: ${response.statusCode}'
        );
      }
                 Logger.print('Wrong getWeather status code: ${response.statusCode}', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
            errorMessageText: 'Wrong getWeather status code: ${response.statusCode}'
      );
    } on Exception catch(e, t) {
               Logger.print('Error getWeather OpenWeatherClient with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
          errorMessageText: 'Error getWeather OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  Future<WeatherData?> _startRcvWeather() async {
    try {

      if(!(await networkInfo.isConnectedWD)) {
        Logger.print('${DateTime.now()}:WeatherClient: No Network Info Status');
        return null;
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
      final weatherData = WeatherData.fromJson(weatherJson);

      return weatherData;
      //
      // Logger.print('weatherDate: ${weatherDate.toJson()}');
      // stackDOW.add(weatherDate);
      // final dataChart = ChartDataValue.fromWeatherDate(
      //     weatherDate,
      //     time: DateTime.now(),
      // );
      // Logger.print(dataChart.toString());
      // stackCDV.add(dataChart);
    } on Exception catch(e, t) {
      Logger.print('Error startRcvWeather OpenWeatherClient with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
          errorMessageText: 'Error startRcvWeather OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  Future<void> _rcvIsolate(SendPort sendPort) async {
    sendPort.send(await _startRcvWeather());
    // Future.delayed(periodic, () async {
    //    final result = await _startRcvWeather();
    //    sendPort.send(result);
    // },);
  }

  Stream<WeatherData?> run2() {
    try {
      return Isolate
          .spawn(_rcvIsolate, receivePort.sendPort)
          .asStream();




    } on Exception catch(e, t) {
      Logger.print('Error run OpenWeatherClient with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
          errorMessageText: 'Error run OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  Stream<WeatherData?> run() async* {
    try {
      yield await _startRcvWeather();
      yield* Stream.periodic(periodic, (tick) {
        try {
          return _startRcvWeather();
        } on OpenWeatherClientException catch(e,t){
          Logger.print('$tick:Error run OpenWeatherClient with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
        }}).asyncMap((event) async => event);
    } on Exception catch(e, t) {
      Logger.print('Error run OpenWeatherClient with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
          errorMessageText: 'Error run OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  void dispose() {

    receivePort.close();
    isolate?.kill();
    streamSubscription?.cancel();
  }

}
