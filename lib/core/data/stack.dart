import 'package:flutter/material.dart';
import 'package:weather_station/common/common.dart';

abstract class CustomStack<T> extends ChangeNotifier{
  final _data = <T>{};
  final int maxCount;

  const CustomStack({
    required this.maxCount,
  });

  int get length => _data.length;
  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  T elementAt(int index) => _data.elementAt(index);
  T get first => _data.first;
  T get last => _data.last;

  void add(T value){
    if(_data.length>=maxCount){
      _data.remove(_data.first);
    }
    _data.add(value);
    notifyListeners();
  }

}
