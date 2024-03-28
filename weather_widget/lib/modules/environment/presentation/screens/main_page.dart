import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _positionStart = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EnvironmentBloc>(context)
            ..add(const EnvironmentEvent.receiveData());
    final settingsApp = context.watch<Settings>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBarWin(
                onPanStart: _onPanStart,
                onPanUpdate: (details) => _onPanUpdate(
                  details,
                  settingsApp,
                  context
                ),
                restart: () => _restart(bloc),
                minimize: windowManager.minimize,
                close: () => _close(settingsApp),
                pinWindows: () => _pinWindows(settingsApp),
              ),
              const EnvironmentWidget(),
            ],
          ),
        ),
        floatingActionButton: const CustomIconEnvironmentStatus(),
      ),
    );
  }

  Future<void> _close(Settings? settingsApp) async {
    await settingsApp?.safeToDisk();
    await windowManager.close();
  }

  Future<void> _restart(EnvironmentBloc bloc) async {
    bloc.add(const EnvironmentEvent.stopGet());
    await Future.delayed(const Duration(seconds: 1));
    bloc
      ..add(const EnvironmentEvent.startGet())
      ..add(const EnvironmentEvent.receiveData());
  }

  Future<bool> _pinWindows(Settings? settingsApp) async {
    if (settingsApp == null) return false;
    settingsApp.floatOnTop = !settingsApp.floatOnTop;
    await windowManager.setAlwaysOnTop(settingsApp.floatOnTop);
    return settingsApp.floatOnTop;
  }

  void _onPanStart(DragStartDetails details) {
    _positionStart = details.globalPosition;
  }

  Future<void> _onPanUpdate(
    DragUpdateDetails details,
    Settings? settingsApp,
    BuildContext? context,
  ) async {
    final position = Offset(
        details.globalPosition.dx /*MediaQuery.of(context).devicePixelRatio*/,
        details.globalPosition.dy /*MediaQuery.of(context).devicePixelRatio*/
    );

    final pos = await windowManager.getPosition();

    if (settingsApp != null) {
      settingsApp.positionStart = pos + position - _positionStart;
    }
    await windowManager.setPosition(pos + position - _positionStart);
    if ((pos.dx + position.dx - _positionStart.dx).toInt().abs() > 20 ||
        (pos.dy + position.dy - _positionStart.dy).toInt().abs() > 20) {
      //await settingsApp.safeToDisk();
    }
  }
}
