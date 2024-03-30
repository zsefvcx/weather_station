
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';
import 'package:window_manager/window_manager.dart';

class MainButtonAction{

  final BuildContext context;

  MainButtonAction({required this.context});

  Future<void> close() async {
    final settingsApp = Provider.of<Settings>(context, listen: false);
    await settingsApp.safeToDisk();
    await windowManager.close();
  }

  Future<void> minimize() async {
    await windowManager.minimize();
  }

  Future<void> restart() async {
    final bloc = BlocProvider.of<EnvironmentBloc>(context)
    ..add(const EnvironmentEvent.stopGet());
    await Future.delayed(const Duration(seconds: 1));
    bloc
      ..add(const EnvironmentEvent.startGet())
      ..add(const EnvironmentEvent.receiveData());
  }

  Future<bool> pinWindows() async {
    final settingsApp = Provider.of<Settings>(context, listen: false);
    settingsApp.floatOnTop = !settingsApp.floatOnTop;
    await windowManager.setAlwaysOnTop(settingsApp.floatOnTop);
    return settingsApp.floatOnTop;
  }

}
