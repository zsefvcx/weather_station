import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_station/common/common.dart';

class CurrentDateTime extends ChangeNotifier {
  DateTime _dataTime = DateTime.now();

  DateTime get dataTime => _dataTime;

  Timer? _timer;

  void update() {
    _dataTime = DateTime.now();
    notifyListeners();
  }

  void run() {
    update();
    _timer = Timer.periodic(Constants.periodicDT, (timer) => update());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
