
import 'package:flutter/material.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/data/weather_date.dart';

class StackDataOpenWeather extends ChangeNotifier{
  static final _data = <WeatherDate>{};
  static const _maxCount = Settings.maxCountStackWD;

  int get length => _data.length;
  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  WeatherDate elementAt(int index) => _data.elementAt(index);
  WeatherDate get first => _data.first;
  WeatherDate get last => _data.last;

  void add(WeatherDate value){
    if(_data.length>=_maxCount){
      _data.remove(_data.first);
    }
    _data.add(value.copyWith(
        id: _data.length
    ));
    notifyListeners();
  }
}
