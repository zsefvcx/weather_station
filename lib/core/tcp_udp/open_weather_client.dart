
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


  //timeLimit - limit await udp response
  final Duration _timeLimit;
  //periodic - frequency of requests
  final Duration _periodic;
  //Chacker network Status
  final NetworkInfo _networkInfo;
  //StreamSubscription
  static StreamSubscription<dynamic>? streamSubscription;
  //Isolate
  static Isolate? _isolate;
  //ReceivePort
  static final ReceivePort _receivePort = ReceivePort();
  //Timer
  static Timer? _timer;

  const OpenWeatherClient({
    required NetworkInfo networkInfo,
    Duration timeLimit = Constants.timeLimitWD,
    Duration periodic = Constants.periodicWD,
  }) : _timeLimit = timeLimit, _periodic = periodic, _networkInfo = networkInfo;

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
      if(!(await _networkInfo.isConnectedWD)) {
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

  void _rcvIsolate(SendPort sendPort) {

    Future.delayed(Duration.zero, () async => sendPort.send(await _startRcvWeather()),);
    // await Stream.periodic(_periodic, (computationCount) {
    //   return _startRcvWeather();
    // },).asyncMap((event) => event).forEach((element) => sendPort.send(element));

    Timer.periodic(_periodic, (timer) async {
      try {
        sendPort.send(await _startRcvWeather());
      } on OpenWeatherClientException catch(e,t){
        Logger.print('${timer.tick}:Error run OpenWeatherClient with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
    }});

  }

  Future<void> _checkNetwork() async {
    if(!(await _networkInfo.isConnectedWD)) {
      Logger.print('${DateTime.now()}:WeatherClient: No Network Info Status');
    }
  }

  //From Isolate
  Future<void> initIsolate() async {
    _isolate = await Isolate.spawn(_rcvIsolate, _receivePort.sendPort);
  }

  Stream<WeatherData?> run2() {
    try {
      Future.delayed(Duration.zero, () async => _checkNetwork(),);
      _timer = Timer.periodic(_periodic, (_) async => _checkNetwork(),);
      return _receivePort.map((event) => (event is WeatherData)?event:null);
      // return Isolate.spawn(_rcvIsolate, _receivePort.sendPort).asStream()
      //      .asyncExpand((event) => _receivePort)
      //      .takeWhile((element) => element is WeatherData?).cast();

    } on Exception catch(e, t) {
      Logger.print('Error run OpenWeatherClient with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
      throw OpenWeatherClientException(
          errorMessageText: 'Error run OpenWeatherClient with:\n$e\n$t'
      );
    }
  }

  //From Stream
  Stream<WeatherData?> run() async* {
    try {
      yield await _startRcvWeather();
      yield* Stream.periodic(_periodic, (tick) {
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

    _timer?.cancel();
    _receivePort.close();
    _isolate?.kill();
    streamSubscription?.cancel();
  }

}
