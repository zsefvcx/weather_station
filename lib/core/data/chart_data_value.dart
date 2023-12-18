import 'package:flutter/material.dart';
import 'package:weather_station/core/core.dart';

@immutable
class ChartDataValue{
  final int? id;
  final DateTime time;
  final num? t1;
  final num? h1;
  final num? p1;
  final num? t2;
  final num? h2;
  final num? p2;
  final num? t3;
  final num? h3;
  final num? p3;

  const ChartDataValue({
    required this.time,
    this.id,
    this.t1,
    this.h1,
    this.p1,
    this.t2,
    this.h2,
    this.p2,
    this.t3,
    this.h3,
    this.p3,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartDataValue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          t1 == other.t1 &&
          h1 == other.h1 &&
          p1 == other.p1 &&
          t2 == other.t2 &&
          h2 == other.h2 &&
          p2 == other.p2 &&
          t3 == other.t3 &&
          h3 == other.h3 &&
          p3 == other.p3);

  @override
  int get hashCode =>
      time.hashCode ^
      id.hashCode ^
      t1.hashCode ^
      h1.hashCode ^
      p1.hashCode ^
      t2.hashCode ^
      h2.hashCode ^
      p2.hashCode ^
      t3.hashCode ^
      h3.hashCode ^
      p3.hashCode;

  @override
  String toString() {
    return 'DataValue{ '
        'time: $time, '
        'id: $id, '
        't1: $t1, '
        'h1: $h1, '
        'p1: $p1, '
        't2: $t2, '
        'h2: $h2, '
        'p2: $p2, '
        't3: $t3, '
        'h3: $h3, '
        'p3: $p3,}';
  }

  ChartDataValue copyWith({
    DateTime? time,
    int? id,
    num? t1,
    num? h1,
    num? p1,
    num? t2,
    num? h2,
    num? p2,
    num? t3,
    num? h3,
    num? p3,
  }) {
    return ChartDataValue(
      time: time ?? this.time,
      id: id ?? this.id,
      t1: t1 ?? this.t1,
      h1: h1 ?? this.h1,
      p1: p1 ?? this.p1,
      t2: t2 ?? this.t2,
      h2: h2 ?? this.h2,
      p2: p2 ?? this.p2,
      t3: t3 ?? this.t3,
      h3: h3 ?? this.h3,
      p3: p3 ?? this.p3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toString(),
      'id': id,
      't1': t1,
      'h1': h1,
      'p1': p1,
      't2': t2,
      'h2': h2,
      'p2': p2,
      't3': t3,
      'h3': h3,
      'p3': p3,
    };
  }

  factory ChartDataValue.fromJson(Map<String, dynamic> map, {
    DateTime? time,
  }) {
    return ChartDataValue(
      time: time ?? DateTime.parse(map['time'] as String),
      id: map['id'] as int?,
      t1: map['t1'] as num?,
      h1: map['h1'] as num?,
      p1: map['p1'] as num?,
      t2: map['t2'] as num?,
      h2: map['h2'] as num?,
      p2: map['p2'] as num?,
      t3: map['t3'] as num?,
      h3: map['h3'] as num?,
      p3: map['p3'] as num?,
    );
  }

  factory ChartDataValue.fromEnvironmentalConditions(EnvironmentalConditions data, {
    DateTime? time,
  }) {
    return ChartDataValue(
      time: time ?? data.time,
      //id: ,
      t1: data.temperature,
      h1: data.humidity,
      //p1: ,
      t2: data.temperature2,
      h2: data.humidity2,
      p2: data.pressure,
      //t3: ,
      //h3: ,
      //p3: ,
    );
  }

  factory ChartDataValue.fromWeatherDate(WeatherDate data, {
    DateTime? time,
  }) {
    return ChartDataValue(
      time: time?? DateTime.now(),
      //id: ,
      //t1: ,
      //h1: ,
      //p1: ,
      //t2: ,
      //h2: ,
      //p2: ,
      t3: data.mainStatus?.temp,
      h3: data.mainStatus?.humidity,
      p3: data.mainStatus?.pressure,
    );
  }


}
