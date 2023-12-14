
import 'package:flutter/foundation.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackDataEnvironmentalConditions extends ChangeNotifier{
  static final _data = <EnvironmentalConditions>{};
  static const _maxCount = Settings.maxCountStackEC;

  int get length => _data.length;
  EnvironmentalConditions elementAt(int index) => _data.elementAt(index);
  EnvironmentalConditions get first => _data.first;
  EnvironmentalConditions get last => _data.last;

  void add(EnvironmentalConditions value){
    if(_data.length>=_maxCount){
      _data.remove(_data.first);
    }
    _data.add(value.copyWith(
        id: _data.length
    ));
    notifyListeners();
  }
}

class StackDataOpenWeather extends ChangeNotifier{
  static final _data = <WeatherDate>{};
  static const _maxCount = Settings.maxCountStackWD;

  int get length => _data.length;
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
