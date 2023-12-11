import 'package:flutter/material.dart';

class DataValue  extends ChangeNotifier{
  late final DateTime time;
  late final double? t1;
  late final double? h1;
  late final double? t2;
  late final double? h2;
  late final double? t3;
  late final double? h3;
  late final double? p3;
  late final double? p1;

  DataValue({
    required this.time,
    required this.t1,
    required this.h1,
    required this.t2,
    required this.h2,
    required this.t3,
    required this.h3,
    required this.p3,
    required this.p1,
  });

  DataValue.fromString(String data) {
    final lStr = data.split('\t');
    time = DateTime.parse(lStr[0] /*'1969-07-20 20:18:04Z'*/);
    t1 = double.parse(lStr[1]);
    h1 = double.parse(lStr[2]);
    t2 = double.parse(lStr[3]);
    h2 = double.parse(lStr[4]);
    t3 = double.parse(lStr[5]);
    h3 = double.parse(lStr[6]);
    p3 = double.parse(lStr[7]);
    p1 = double.parse(lStr[8]);
  }

  String toLegend(){
    return
      'Data Time\t'
          'T °C\t'
          'H %\t'
          'T2 °C\t'
          'H2 %\t'
          'T3 °C\t'
          'H3 %\t'
          'P3 mmHg\t'
          'P mmHg\n';
  }

  @override
  String toString() {
    return
      '${time.year.toString().padLeft(4, '0')}-'
          '${time.month.toString().padLeft(2, '0')}-'
          '${time.day.toString().padLeft(2, '0')} '
          '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}:'
          '${time.second.toString().padLeft(2, '0')}Z\t'
          '$t1\t'
          '$h1\t'
          '$t2\t'
          '$h2\t'
          '$t3\n'
          '$h3\t'
          '$p3\t'
          '$p1\n'
    ;
  }

  void notify(){
    notifyListeners();
  }
}
