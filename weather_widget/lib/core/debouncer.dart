
import 'dart:async';

import 'package:flutter/material.dart';

///Класс который откладывает действия
class Debouncer {
  ///Задержка перед вызовом
  final Duration delay;
  ///Внутренний таймер
  Timer? _timer;

  Debouncer(this.delay);

  void debounce(Future<void> Function() action){
      //Отменяем прошлый таймер
      _timer?.cancel();
      //Запускаем таймер по истечении времени запускаем действие.
      _timer = Timer(delay, () => action());
  }

  void dispose() => _timer?.cancel();
}
