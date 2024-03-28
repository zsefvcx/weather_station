import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class CustomAppBarWin extends StatelessWidget {
  const CustomAppBarWin({
    required this.onPanStart,
    required this.onPanUpdate,
    required Future<void> Function() close,
    required Future<void> Function() minimize,
    required Future<void> Function() restart,
    required Future<bool> Function() pinWindows,
    super.key,
  })  : _pinWindows = pinWindows,
        _restart = restart,
        _minimize = minimize,
        _close = close;

  final void Function(DragStartDetails details) onPanStart;
  final void Function(DragUpdateDetails details) onPanUpdate;
  final Future<bool> Function() _pinWindows;
  final Future<void> Function() _restart;
  final Future<void> Function() _minimize;
  final Future<void> Function() _close;

  @override
  Widget build(BuildContext context) {
    final actions = <({
      Future<dynamic> Function() function,
      IconData icon,
      IconData? icon2,
      String tooltip,
    })>{
      (
        function: _pinWindows,
        icon: Icons.check_box_outline_blank,
        icon2: Icons.library_add_check_outlined,
        tooltip: 'Pin'.hrd
      ),
      (
        function: _restart,
        icon: Icons.restart_alt,
        icon2: null,
        tooltip: 'Restart'.hrd
      ),
      (
        function: _minimize,
        icon: Icons.minimize,
        icon2: null,
        tooltip: 'Minimize'.hrd
      ),
      (function: _close, icon: Icons.close, icon2: null, tooltip: 'Close'.hrd),
    };

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: Container(
          color: black,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...actions.map((e) => CustomIconButton(
                    e.icon,
                    icon2: e.icon2,
                    onPressed: e.function,
                    tooltip: e.tooltip,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
