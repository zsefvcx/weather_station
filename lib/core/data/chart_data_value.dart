import 'package:flutter/material.dart';

@immutable
class ChartDataValue{
  final DateTime time;
  final double? t1;
  final double? h1;
  final double? p1;
  final double? t2;
  final double? h2;
  final double? p2;
  final double? t3;
  final double? h3;
  final double? p3;

  const ChartDataValue({
    required this.time,
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
    double? t1,
    double? h1,
    double? p1,
    double? t2,
    double? h2,
    double? p2,
    double? t3,
    double? h3,
    double? p3,
  }) {
    return ChartDataValue(
      time: time ?? this.time,
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

  Map<String, dynamic> toMap() {
    return {
      'time': time,
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

  factory ChartDataValue.fromMap(Map<String, dynamic> map) {
    return ChartDataValue(
      time: map['time'] as DateTime,
      t1: map['t1'] as double,
      h1: map['h1'] as double,
      p1: map['p1'] as double,
      t2: map['t2'] as double,
      h2: map['h2'] as double,
      p2: map['p2'] as double,
      t3: map['t3'] as double,
      h3: map['h3'] as double,
      p3: map['p3'] as double,
    );
  }

}
