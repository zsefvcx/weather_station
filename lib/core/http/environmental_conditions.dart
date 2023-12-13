import 'package:flutter/material.dart';
import 'package:weather_station/core/core.dart';

class EnvironmentalConditionsException implements Exception {
  final String errorMessageText;

  const EnvironmentalConditionsException({
    required this.errorMessageText,
  });

  String errorMessage() {
    return 'Environmental Conditions Exception: $errorMessageText';
  }
}

class StackDataEnvironmentalConditions extends ChangeNotifier{
  static final _data = <EnvironmentalConditions>[];
  static const _maxCount = Settings.maxCountStack;

  int get length => _data.length;
  EnvironmentalConditions elementAt(int index) => _data.elementAt(index);

  void add(EnvironmentalConditions value){
    if(_data.length>=_maxCount){
      _data.removeLast();
    }
    _data.add(value);
    notifyListeners();
  }
}

//неизменный
@immutable
class EnvironmentalConditions {
  final int? id;
  final DateTime time;
  final String host;
  final bool alarm;
  final bool error;
  final bool error2;
  final double temperature;
  final double humidity;
  final double pressure;
  final double altitude;
  final double temperature2;
  final double humidity2;

  const EnvironmentalConditions._({
    required this.time,
    required this.host,
    required this.alarm,
    required this.error,
    required this.error2,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.id,
    required this.altitude,
    required this.temperature2,
    required this.humidity2,
  });

  static T _checkValueDouble<T>({
    required T value,
    required double min,
    required double max
  }) {
    if(value==null) return null as T;
    if(value is! double){
      throw const EnvironmentalConditionsException(
          errorMessageText: 'Value is not а double.'
      );
    }
    if (value < min || value > max) {
      throw EnvironmentalConditionsException(
          errorMessageText: 'Value:$value is not а range from $min to $max.'
      );
    }
    return value;
  }

  factory EnvironmentalConditions.initiate({
    required int? id,
    required DateTime time,
    required String host,
    required bool alarm,
    required bool error,
    required bool error2,
    required double temperature,
    required double humidity,
    required double pressure,
    required double altitude,
    required double temperature2,
    required double humidity2,
  }){

    final temperatureDone = _checkValueDouble(value: temperature, min: -75, max: 50);
    final temperature2Done = _checkValueDouble(value: temperature2, min: -75, max: 50);
    final humidityDone = _checkValueDouble(value: humidity, min: 0, max: 100);
    final humidity2Done = _checkValueDouble(value: humidity2, min: 0, max: 100);
    final pressureDone = _checkValueDouble(value: pressure, min: 720, max: 790);
    final altitudeDone = _checkValueDouble(value: altitude, min: -3000, max: 3000);

    return EnvironmentalConditions._(
      id: id,
      time: time,
      host: host,
      alarm: alarm,
      error: error,
      error2: error2,
      temperature: temperatureDone,
      temperature2: temperature2Done,
      humidity: humidityDone,
      humidity2: humidity2Done,
      pressure: pressureDone,
      altitude: altitudeDone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvironmentalConditions &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          host == other.host &&
          alarm == other.alarm &&
          error == other.error &&
          error2 == other.error2 &&
          temperature == other.temperature &&
          humidity == other.humidity &&
          pressure == other.pressure &&
          altitude == other.altitude &&
          temperature2 == other.temperature2 &&
          humidity2 == other.humidity2);

  @override
  int get hashCode =>
      id.hashCode ^
      time.hashCode ^
      host.hashCode ^
      alarm.hashCode ^
      error.hashCode ^
      error2.hashCode ^
      temperature.hashCode ^
      humidity.hashCode ^
      pressure.hashCode ^
      altitude.hashCode ^
      temperature2.hashCode ^
      humidity2.hashCode;

  @override
  String toString() {
    return 'EnvironmentalConditions{ '
        'id: $id, '
        'time: $time, '
        'host: $host, '
        'alarm: $alarm, '
        'error: $error, '
        'error2: $error2, '
        'temperature: $temperature, '
        'humidity: $humidity, '
        'pressure: $pressure, '
        'altitude: $altitude, '
        'temperature2: $temperature2, '
        'humidity2: $humidity2}';
  }

  EnvironmentalConditions copyWith({
    int? id,
    DateTime? time,
    String? host,
    bool? alarm,
    bool? error,
    bool? error2,
    String? sending,
    double? temperature,
    double? humidity,
    double? pressure,
    double? altitude,
    double? temperature2,
    double? humidity2,
  }) {
    return EnvironmentalConditions.initiate(
      id: id ?? this.id,
      time: time ?? this.time,
      host: host ?? this.host,
      alarm: alarm ?? this.alarm,
      error: error ?? this.error,
      error2: error2 ?? this.error2,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      altitude: altitude ?? this.altitude,
      temperature2: temperature2 ?? this.temperature2,
      humidity2: humidity2 ?? this.humidity2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toString(),
      'host': host,
      'alarm': alarm,
      'error': error,
      'error2': error2,
      'temperature': (temperature*100).toInt(),
      'humidity': (humidity*100).toInt(),
      'pressure': (pressure*100).toInt(),
      'altitude': (altitude*100).toInt(),
      'temperature2': (temperature2*100).toInt(),
      'humidity2': (humidity2*100).toInt(),
    };
  }

  factory EnvironmentalConditions.fromJson(Map<String, dynamic> map, {
    DateTime? time, String? host,
  }) {
    return EnvironmentalConditions.initiate(
      id:           map['id']           as int?,
      time:         time ?? DateTime.parse(map['time'] as String),
      host:         host ?? map['host'] as String,
      alarm:        map['alarm']        as bool,
      error:        map['error']        as bool,
      error2:       map['error2']       as bool,
      temperature:  (map['temperature']  as int).toDouble()/100,
      humidity:     (map['humidity']     as int).toDouble()/100,
      pressure:     (map['pressure']     as int).toDouble()/100,
      altitude:     (map['altitude']     as int).toDouble()/100,
      temperature2: (map['temperature2'] as int).toDouble()/100,
      humidity2:    (map['humidity2']    as int).toDouble()/100,
    );
  }
}
