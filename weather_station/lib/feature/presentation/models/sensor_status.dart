
import 'package:flutter/cupertino.dart';

@immutable
class SensorStatus {
  final num? temp;
  final num? humid;
  final num? press;
  final int numberWidget;
  final String typeSensor;

  const SensorStatus({
    required this.temp,
    required this.humid,
    required this.numberWidget,
    required this.typeSensor,
    this.press,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SensorStatus &&
          runtimeType == other.runtimeType &&
          temp == other.temp &&
          humid == other.humid &&
          press == other.press &&
          numberWidget == other.numberWidget &&
          typeSensor == other.typeSensor);

  @override
  int get hashCode =>
      temp.hashCode ^
      humid.hashCode ^
      press.hashCode ^
      numberWidget.hashCode ^
      typeSensor.hashCode;

  @override
  String toString() {
    return 'SensorStatus{ '
        'temp: $temp, '
        'humid: $humid, '
        'press: $press, '
        'numberWidget: $numberWidget, '
        'typeSensor: $typeSensor,}';
  }

  SensorStatus copyWith({
    double? temp,
    num? humid,
    num? press,
    int? numberWidget,
    String? typeSensor,
  }) {
    return SensorStatus(
      temp: temp ?? this.temp,
      humid: humid ?? this.humid,
      press: press ?? this.press,
      numberWidget: numberWidget ?? this.numberWidget,
      typeSensor: typeSensor ?? this.typeSensor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'humid': humid,
      'press': press,
      'numberWidget': numberWidget,
      'typeSensor': typeSensor,
    };
  }

  factory SensorStatus.fromJson(Map<String, dynamic> map) {
    return SensorStatus(
      temp: map['temp'] as double,
      humid: map['humid'] as num,
      press: map['press'] as num,
      numberWidget: map['numberWidget'] as int,
      typeSensor: map['typeSensor'] as String,
    );
  }

}
