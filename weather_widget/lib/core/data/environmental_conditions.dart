import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';

//неизменный
@immutable
class EnvironmentalConditions {
  final int? id;
  final DateTime time;
  final String host;
  final TypeDataRcv type;
  final bool alarm;
  final bool error;
  final bool error2;
  final double? temperature;
  final double? humidity;
  final double? pressure;
  final double? altitude;
  final double? temperature2;
  final double? humidity2;
  final double? pressure2;

  const EnvironmentalConditions._({
    required this.time,
    required this.host,
    required this.type,
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
    required this.pressure2,
  });

  static T _checkValueDouble<T>({
    required T value,
    required double min,
    required double max
  }) {
    if(value==null) return null as T;
    if(value is! double){
      throw EnvironmentalConditionsException(
          errorMessage: 'Value is not а double.'
      );
    }
    if (value < min || value > max) {
      throw EnvironmentalConditionsException(
          errorMessage: 'Value:$value is not а range from $min to $max.'
      );
    }
    return value;
  }

  factory EnvironmentalConditions.initiate({
    required int? id,
    required DateTime time,
    required String host,
    required TypeDataRcv type,
    required bool alarm,
    required bool error,
    required bool error2,
    required double? temperature,
    required double? humidity,
    required double? pressure,
    required double? altitude,
    required double? temperature2,
    required double? humidity2,
    required double? pressure2,
  }){

    final temperatureDone = temperature!=null
        ?_checkValueDouble(value: temperature, min: -75, max: 50):null;
    final humidityDone = humidity!=null
        ?_checkValueDouble(value: humidity, min: 0, max: 100):null;
    final altitudeDone = altitude!=null
        ?_checkValueDouble(value: altitude, min: -3000, max: 3000):null;
    final pressureDone = pressure!=null
        ?_checkValueDouble(value: pressure, min: 720, max: 790):null;


    final temperature2Done = (temperature2!= null && !error2)
        ?_checkValueDouble(value: temperature2, min: -75, max: 50):null;
    final humidity2Done = (temperature2!= null && !error2)
        ?_checkValueDouble(value: humidity2, min: 0, max: 100):null;
    final pressure2Done = (temperature2!= null && !error2)
        ?_checkValueDouble(value: pressure2, min: 720, max: 790):null;


    return EnvironmentalConditions._(
      id: id,
      time: time,
      host: host,
      type: type,
      alarm: alarm,
      error: error,
      error2: error2,
      temperature: temperatureDone,
      temperature2: temperature2Done,
      humidity: humidityDone,
      humidity2: humidity2Done,
      pressure: pressureDone,
      altitude: altitudeDone,
      pressure2: pressure2Done,
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
          type == other.type &&
          alarm == other.alarm &&
          error == other.error &&
          error2 == other.error2 &&
          temperature == other.temperature &&
          humidity == other.humidity &&
          pressure == other.pressure &&
          altitude == other.altitude &&
          temperature2 == other.temperature2 &&
          humidity2 == other.humidity2) &&
          pressure2 == other.pressure2;

  @override
  int get hashCode =>
      id.hashCode ^
      time.hashCode ^
      host.hashCode ^
      type.hashCode ^
      alarm.hashCode ^
      error.hashCode ^
      error2.hashCode ^
      temperature.hashCode ^
      humidity.hashCode ^
      pressure.hashCode ^
      altitude.hashCode ^
      temperature2.hashCode ^
      humidity2.hashCode ^
      pressure2.hashCode;

  @override
  String toString() {
    return 'EnvironmentalConditions{ '
        'id: $id, '
        'time: $time, '
        'host: $host, '
        'type: $type, '
        'alarm: $alarm, '
        'error: $error, '
        'error2: $error2, '
        'temperature: $temperature, '
        'humidity: $humidity, '
        'pressure: $pressure, '
        'altitude: $altitude, '
        'temperature2: $temperature2, '
        'humidity2: $humidity2, '
        'pressure2: $pressure2}';

  }

  EnvironmentalConditions copyWith({
    int? id,
    DateTime? time,
    String? host,
    TypeDataRcv? type,
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
    double? pressure2,
  }) {
    return EnvironmentalConditions.initiate(
      id: id ?? this.id,
      time: time ?? this.time,
      host: host ?? this.host,
      type: type ?? this.type,
      alarm: alarm ?? this.alarm,
      error: error ?? this.error,
      error2: error2 ?? this.error2,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      altitude: altitude ?? this.altitude,
      temperature2: temperature2 ?? this.temperature2,
      humidity2: humidity2 ?? this.humidity2,
      pressure2: pressure2 ?? this.pressure2,
    );
  }

  Map<String, dynamic> toJson() {
    int? toInt(double? value){
      if(value != null){
        return (value*100).toInt();
      }
      return null;
    }

    return {
      'id': id,
      'time': time.toString(),
      'host': host,
      'type: ${type.index}, '
      'alarm': alarm,
      'error': error,
      'error2': error2,
      'temperature': toInt(temperature),
      'humidity': toInt(humidity),
      'pressure': toInt(pressure),
      'altitude': toInt(altitude),
      'temperature2': toInt(temperature2),
      'humidity2': toInt(humidity2),
      'pressure2': toInt(pressure2),
    };
  }

  factory EnvironmentalConditions.fromJson(Map<String, dynamic> map, {
    DateTime? time, String? host, TypeDataRcv? type,
  }) {
    double? add(entry, double deltaValue){
      final val = entry as num?;
      if(val != null){
        return ((val+deltaValue).toInt())/100;
      }
      return null;
    }

    return EnvironmentalConditions.initiate(
      id:           map['id']            as int?,
      time:         time ?? DateTime.parse(map['time'] as String),
      host:         host ?? map['host']  as String,
      type:         type ?? TypeDataRcv.values.elementAt(map['type'] as int),
      alarm:        map['alarm']         as bool,
      error:        map['error']         as bool,
      error2:       map['error2']        as bool,
      temperature:  add(map['temperature'], Settings.calibrationTemperature2),
      humidity:     add(map['humidity'], 0),
      pressure:     add(map['pressure'], Settings.calibrationPressure2),
      altitude:     add(map['altitude'], 0),
      temperature2: add(map['temperature2'], Settings.calibrationTemperature2),
      humidity2:    add(map['humidity2'], 0),
      pressure2:    add(map['pressure2'], Settings.calibrationPressure2),
    );
  }
}
