
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';
import 'package:window_manager/window_manager.dart';

class MainButtonAction{

  final BuildContext context;

  final Throttler _throttler = Throttler(const Duration(milliseconds: 500));

  MainButtonAction({required this.context});

  Future<void> close() async => _throttler.throttle(() async => _close(), );
  Future<void> _close() async {
    final settingsApp = Provider.of<Settings>(context, listen: false);
    await settingsApp.safeToDisk();
    await windowManager.close();
  }

  Future<void> minimize() async => _throttler.throttle(() async => _minimize(), );
  Future<void> _minimize() async {
    await windowManager.minimize();
  }

  Future<void> stop() async => _throttler.throttle(() async => _stop(), );
  Future<void> _stop() async {
    BlocProvider.of<EnvironmentBloc>(context).add(const EnvironmentEvent.stopGet());
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> start() async => _throttler.throttle(() async => _start(), );
  Future<void> _start() async {
    BlocProvider.of<EnvironmentBloc>(context)
      ..add(const EnvironmentEvent.startGet())
      ..add(const EnvironmentEvent.receiveData());
  }

  Future<void> restart() async => _throttler.throttle(() async => _restart(), );
  Future<void> _restart() async {
    final bloc = BlocProvider.of<EnvironmentBloc>(context)..add(const EnvironmentEvent.stopGet());
    await Future.delayed(const Duration(seconds: 1));
    bloc..add(const EnvironmentEvent.startGet())
      ..add(const EnvironmentEvent.receiveData());
  }

  Future<void> pinWindows() async => _throttler.throttle(() async => _pinWindows(), );
  Future<bool> _pinWindows() async {
    final settingsApp = Provider.of<Settings>(context, listen: false);
    settingsApp.floatOnTop = !settingsApp.floatOnTop;
    await windowManager.setAlwaysOnTop(settingsApp.floatOnTop);
    return settingsApp.floatOnTop;
  }

  void dispose(){
    _throttler.dispose();
  }
}
