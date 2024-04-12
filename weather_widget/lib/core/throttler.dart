
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';

///Класс который запрещает повторные действия
class Throttler {
  ///Задержка перед вызовом
  final Duration delay;
  ///Внутренний таймер
  Timer? _timer;
  ///Флаг троттлинга
  bool _isThrottling = false;

  Throttler(this.delay);

  Future<T?> throttle<T>(Future<T> Function() action) async {
    // если не выполняется тротлинг, выполняем действие и запускаем таймер для обновление флага
    if (!_isThrottling){
      //Выполняем действие
      final res = action();
      //Обновляем флаг
      _isThrottling = true;
      //Запускаем таймер по истечении времени сбрасываем флаг.
      _timer = Timer(delay, () => _isThrottling = false);

      return res;
    }
    Logger.print('${DateTime.now()}:Too Fast');
    return null;
  }

  void dispose() => _timer?.cancel();
}
