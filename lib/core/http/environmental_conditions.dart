//import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_station/core/core.dart';


class EnvConditions extends ChangeNotifier {
  static const String id = 'AAAAAB_KEY:16032023';
  late DateTime time;
  TypeDataReceiver type = TypeDataReceiver.type0; // 1 - multicast; 2 - client;
  bool alarm = false;
  double? temp1;
  double? humid1;
  bool err1 = false;
  double? temp2;
  double? humid2;
  bool err2 = false;
  double? temp3;
  double? humid3;
  double? press3;
  bool err3 = false;
  double? press;
  double? altitude;
  String? host;

  late Future<SharedPreferences> prefs;

  int errorStatSingle = 0;
  int errorStateBroadCast = 0;

  EnvConditions({required this.time});

  double? checkValueTemp<T>(
      {required T value, required double min, required double max}) {
    double? buff;
    if (value is String) {
      buff = double.parse(value);
    }
    if (value is double) {
      buff = value;
    } else {
      alarm = true;
      return null;
    }
    //если что вывалиться с ошибкой то она отловиться
    if (buff < min || buff > max) {
      alarm = true;
      return null;
    }
    return buff;
  }

  void fromJsonOpenWeatherMap(
      Map<String, dynamic> json, String host, DateTime time) {
    /*body_json: {coord: {lon: 42.0752, lat: 51.368},
    weather: [{id: 804, main: Clouds, description: overcast clouds, icon: 04d}],
    base: stations,
    main: {temp: 13.12, feels_like: 11.4, temp_min: 13.12, temp_max: 13.12, pressure: 1031, humidity: 35, sea_level: 1031, grnd_level: 1018},
    visibility: 10000,
    wind: {speed: 2.96, deg: 124, gust: 3.72},
    clouds: {all: 87},
    dt: 1681721462,
    sys: {country: RU, sunrise: 1681697573, sunset: 1681747767},
    timezone: 10800, id: 572525, name: Borisoglebsk, cod: 200}*/
    final data = json['main'] as Map<String, dynamic>;
    try {
      temp3 = double.parse(data['temp'].toString());
      humid3 = double.parse(data['humidity'].toString());
      err3 = false;
      press3 =
      (double.parse(data['pressure'].toString())*10.0).roundToDouble()/10;
      time = time;
    } on Exception catch (_) {
      err3 = true;
    }
  }

  void fromJson(Map<String, dynamic> json, String host, DateTime time) {

    alarm = (json['alarm'] as bool?) ?? false;
    temp1 = checkValueTemp(value: (json['val0'] as double) / 100.0, min: -75, max: 50);
    humid1 = checkValueTemp(value: (json['val1'] as double)/ 100.0, min: 0, max: 100);
    err1 = (json['err'] as bool?) ?? false;
    temp2 = checkValueTemp(value: (json['val2'] as double)/ 100.0, min: -75, max: 50);
    humid2 = checkValueTemp(value: (json['val3'] as double)/ 100.0, min: 0, max: 100);
    err2 = (json['err'] as bool?) ?? false;
    press = checkValueTemp(value: (json['val4'] as double)/ 100.0, min: 720, max: 790);
    host = host;
    altitude = checkValueTemp(value: (json['val5'] as double)/ 100.0, min: 0, max: 3000);
    time = time;
  }

  Map<String, dynamic> toJson() => {
        'ID': 'AAAAAB_KEY:16032023',
        'alarm': alarm,
        'val0': temp1! * 100,
        'val1': humid1! * 100,
        'err': err1,
        'val2': temp2! * 100,
        'val3': humid2! * 100,
        'val4': press! * 100,
        'val5': altitude! * 100,
        'err2': err2,
      };

  void fromString(String data) {
    final lStr = data.split('\t');
    time = DateTime.parse(lStr[0] /*'1969-07-20 20:18:04Z'*/);
    temp1 = checkValueTemp(value: lStr[1], min: -75, max: 50);
    humid1 = checkValueTemp(value: lStr[2], min: 0, max: 100);
    temp2 = checkValueTemp(value: lStr[3], min: -75, max: 50);
    humid2 = checkValueTemp(value: lStr[4], min: 0, max: 100);
    press = checkValueTemp(value: lStr[5], min: 720, max: 790);
    altitude = checkValueTemp(value: lStr[6], min: 0, max: 3000);
  }

  Future<void> readFromDisk() async {
    try{
      final prefs = await this.prefs;
      final now = DateTime.now();
      alarm = prefs.getBool('alarm')??false;
      temp1 = prefs.getDouble('temp1');
      humid1 = prefs.getDouble('humid1');
      err1 = prefs.getBool('err1')??false;
      temp2 = prefs.getDouble('temp2');
      humid2 = prefs.getDouble('humid2');
      err2 = prefs.getBool('err2')??false;
      temp3 = prefs.getDouble('temp3');
      humid3 = prefs.getDouble('humid3');
      err3 = prefs.getBool('err3')??false;
      press = prefs.getDouble('press');
      press3 = prefs.getDouble('press3');
      altitude = prefs.getDouble('altitude');
      host = prefs.getString('host');
      time = now;
      type = TypeDataReceiver.type0;
    } on Exception catch(e){
      Logger.print(e.toString());
      clean();
      //await safeToDisk();
    }
  }

  Future<void> safeToDisk() async {
    try{
      final prefs = await this.prefs;
      await prefs.setBool('alarm',alarm);
      await prefs.setBool('err1',err1);
      await prefs.setBool('err2',err2);
      await prefs.setBool('err3',err3);
      if(temp1==null) {
        await prefs.remove('temp1');
      } else {
        await prefs.setDouble('temp1',temp1!);
      }
      if(temp2==null) {
        await prefs.remove('temp2');
      } else {
        await prefs.setDouble('temp2',temp2!);
      }
      if(temp3==null) {
        await prefs.remove('temp3');
      } else {
        await prefs.setDouble('temp3',temp3!);
      }
      if(humid1==null) {
        await prefs.remove('humid1');
      } else {
        await prefs.setDouble('humid1',humid1!);
      }
      if(humid2==null) {
        await prefs.remove('humid2');
      } else {
        await prefs.setDouble('humid2',humid2!);
      }
      if(humid3==null) {
        await prefs.remove('humid3');
      } else {
        await prefs.setDouble('humid3',humid3!);
      }
      if(press==null) {
        await prefs.remove('press');
      } else {
        await prefs.setDouble('press',press!);
      }
      if(press3==null) {
        await prefs.remove('press3');
      } else {
        await prefs.setDouble('press3',press3!);
      }
      if(altitude==null) {
        await prefs.remove('altitude');
      } else {
        await prefs.setDouble('altitude',altitude!);
      }
      if(host==null) {
        await prefs.remove('host');
      } else {
        await prefs.setString('host',host!);
      }
    } on Exception catch(e){
        Logger.print(e.toString());
    }
  }


  void clean() {
    final now = DateTime.now();
    alarm = false;
    temp1 = null;
    humid1 = null;
    err1 = false;
    temp2 = null;
    humid2 = null;
    err2 = false;
    temp3 = null;
    humid3 = null;
    err3 = false;
    press = null;
    press3 = null;
    altitude = null;
    host = null;
    time = now;
    type = TypeDataReceiver.type0;
  }

  String toLegend() {
    return 'Data Time\t'
        'type\t'
        'alarm\t'
        'host\t'
        'T, °C\t'
        'H, %\t'
        'err\t'
        'T2, °C\t'
        'H2, %\t'
        'err2\t'
        'P, mmHg\t'
        'A, m\n';
  }

  @override
  String toString() {
    return '\nData Time\t\t\t\t'
        'type\t\t'
        'alarm\t'
        'host\t\t\t'
        'T, °C\t'
        'H, %\t'
        'err\t\t'
        'T2, °C\t'
        'H2, %\t'
        'err2\t'
        'T3, °C\t'
        'H3, %\t'
        'err3\t'
        'P, mmHg\t'
        'P3, mmHg\t'
        'A, m\n'
        '${time.year.toString().padLeft(4, '0')}-'
        '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}Z\t'
        '$type\t'
        '$alarm\t'
        '$host\t'
        '$temp1\t'
        '$humid1\t'
        '$err1\t'
        '$temp2\t'
        '$humid2\t'
        '$err2\t'
        '$temp3\t'
        '$humid3\t'
        '$err3\t'
        '$press\t'
        '$press3\t'
        '$altitude\n';
  }
  void notify() {
    notifyListeners();
  }


}
