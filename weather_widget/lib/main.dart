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
      size: Settings.sizeLite,
      center: true,
      alwaysOnTop: false,
      fullScreen: false,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
      title: '~°C~%~mmHg~',
      backgroundColor: Colors.transparent,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setOpacity(settingsApp.opacityLite);
      await windowManager.setAlwaysOnTop(settingsApp.floatOnTop);
      await windowManager.setMaximumSize(Settings.sizeLite);
      await windowManager.setMinimumSize(Settings.sizeLite);
      await windowManager.setPosition(settingsApp.positionStart);
      await windowManager.setSize(Settings.sizeLite);
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
