import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_station/common/common.dart';

///Логгер в систему.
abstract class Logger {
  /// - [message] is the log message
  /// - [name] (optional) is the name of the source of the log message
  /// - [level] (optional) is the severity level (a value between 0 and 2000);
  /// - [error] (optional) an error bool associated with this log event
  /// - [context] (optional) for SnackBsr
  /// - [safeToDisk] (optional) for safe data to disk
  ///@Deprecated('Print status message')
  static void print(
    String message, {
    String name = 'log',
    int level = 0,
    bool error = false,
    BuildContext? context,
    bool safeToDisk = false,
  }) {
    final msg = message;
    if (kDebugMode || Settings.showLogData) {
      dev.log(
        '|:${error ? 'E' : 'N'}:|$msg',
        time: DateTime.now(),
        name: name,
        level: level,
      );
    }
    // assert(() {
    //   // ...debug-only code here...
    //   return true;
    // }());
    if (context != null) CustomShowSnackBar.showSnackBar(msg, context);

    if (safeToDisk) {
      Future<void> function() async {
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final localPath = error?'$path/logger_error.txt':'$path/logger_data.txt';
        Logger.print(localPath);
        final file = File(localPath);
        await file.writeAsString('$msg\n', mode: FileMode.append);
      }

      try {
        function();
      } on Exception catch (e, t) {
        Exception('Logger->print->safeToDisk Exception with:\n$e\n$t');
      }
    }
  }
}
