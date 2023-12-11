import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_station/core/core.dart';



///Логгер в систему.
abstract class Logger {
  /// - [message] is the log message
  /// - [name] (optional) is the name of the source of the log message
  /// - [level] (optional) is the severity level (a value between 0 and 2000);
  /// - [error] (optional) an error bool associated with this log event
  ///@Deprecated('Print status message')
  static void print(String message, {
      String name = 'log',
      int level = 0,
      bool error = false,
      BuildContext? context,
    }) {
    final msg = message;
    if (kDebugMode || Settings.showLogData) {
      dev.log(
        '|:${error?'E':'N'}:|$msg',
        time: DateTime.now(),
        name: name,
        level: level,
      );
    }
    // assert(() {
    //   // ...debug-only code here...
    //   return true;
    // }());
    if (context != null)  CustomShowSnackBar.showSnackBar(msg, context);
  }
}
