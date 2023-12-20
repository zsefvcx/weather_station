import 'package:flutter/material.dart';

abstract class CustomStack<T> extends ChangeNotifier{
  final Set<T> _data = <T>{};
  final int _maxCount;
  DateTime startStack = DateTime.now();

  CustomStack({
    required int maxCount,
  }) : _maxCount = maxCount;

  List<T> get toList => _data.toList();
  Set<T>  get toSet => _data;
  int get length => _data.length;
  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  T elementAt(int index) => _data.elementAt(index);
  T get first => _data.first;
  T get last => _data.last;

  DateTime? _lastDateTime;

  void add(T value){
    if(_data.length>=_maxCount){
      _data.remove(_data.first);
    }
    if(DateTime.now().day != startStack.day){
      startStack = DateTime.now();
    }
    final nowOnlySeconds = DateTime.now().copyWith(
      millisecond: 0,
      microsecond: 0,
    );
    final lastDateTime = _lastDateTime;

    if((lastDateTime !=null && lastDateTime != nowOnlySeconds)
      ||lastDateTime ==null){
      _lastDateTime = nowOnlySeconds;
      _data.add(value);
      notifyListeners();
    }
  }

}
