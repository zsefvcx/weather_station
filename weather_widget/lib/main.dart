import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_widget/app.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/modules.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  final settingsApp = Settings();
  FeatureBlocsInit.initState();
  settingsApp.prefs = SharedPreferences.getInstance();
  await settingsApp.readFromDisk();

  if (Platform.isMacOS   || Platform.isLinux || Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Constants.sizeLite,
      center: false,
      alwaysOnTop: false,
      fullScreen: false,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
      title: Constants.title,
      backgroundColor: Colors.transparent,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setOpacity(settingsApp.opacity);
      await windowManager.setAlwaysOnTop(settingsApp.floatOnTop);
      ///Установить максимальные размер
      await windowManager.setMaximumSize(Constants.sizeLiteDouble);
      ///Установить минимальные размеры
      await windowManager.setMinimumSize(settingsApp.iDouble==1
          ?Constants.sizeLite
          :Constants.sizeLiteDouble
      );
      await windowManager.setPosition(settingsApp.positionStart);
      await windowManager.setSize(Constants.sizeLite);
      ///Делает окно без возможности изменять размеры
      await windowManager.setAsFrameless();
      await windowManager.show();
      await windowManager.focus();
    });
  }



  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Settings>(create: (_) => settingsApp,),
    ],

      child: const App())
  );
}
