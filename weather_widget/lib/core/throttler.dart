
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

  void throttle(VoidCallback action){
    // если не выполняется тротлинг, выполняем действие и запускаем таймер для обновление флага
    if (!_isThrottling){
      //Выполняем действие
      action();
      //Обновляем флаг
      _isThrottling = true;
      //Запускаем таймер по истечении времени сбрасываем флаг.
      _timer = Timer(delay, () => _isThrottling = false);
    } else {
      Logger.print('${DateTime.now()}:Too Fast');
    }
  }

  void dispose() => _timer?.cancel();
}
