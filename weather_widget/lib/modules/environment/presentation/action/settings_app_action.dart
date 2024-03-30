
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_widget/core/core.dart';
import 'package:window_manager/window_manager.dart';

class SettingsAppAction {
  SettingsAppAction({required this.context});

  final BuildContext context;

  Future<void> opacityChanged(double value) async{
    final settingsApp = Provider.of<Settings>(context, listen: false);
    if (value < 0.5) {
      settingsApp.opacity = 0.5;
    } else {
      settingsApp.opacity = value;
    }
    await windowManager.setOpacity(settingsApp.opacity);
    await settingsApp.safeToDisk();
  }



}
