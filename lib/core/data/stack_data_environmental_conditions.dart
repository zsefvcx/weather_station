
import 'package:flutter/foundation.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class StackDataEnvironmentalConditions extends ChangeNotifier{
  static final _data = <EnvironmentalConditions>{};
  static const _maxCount = Settings.maxCountStackEC;

  int get length => _data.length;
  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

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
