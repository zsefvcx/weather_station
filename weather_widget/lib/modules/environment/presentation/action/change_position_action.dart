import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_widget/core/core.dart';
import 'package:window_manager/window_manager.dart';

class ChangePositionAction {
  ChangePositionAction({required this.context});

  final BuildContext context;

  var _positionStart = Offset.zero;

  void onPanStart(DragStartDetails details) {
    _positionStart = details.globalPosition;
  }

  Future<void> onPanUpdate(DragUpdateDetails details) async {
    final settingsApp = Provider.of<Settings>(context, listen: false);

    var deltaY = 0;
    if(Platform.isLinux){
      deltaY = 31;
    }

    final position = Offset(
        details.globalPosition.dx /*MediaQuery.of(context).devicePixelRatio*/,
        details.globalPosition.dy /*MediaQuery.of(context).devicePixelRatio*/+deltaY,
        );

    final pos = await windowManager.getPosition();

    settingsApp.positionStart = pos + position - _positionStart;

    await windowManager.setPosition(pos + position - _positionStart);
    if ((pos.dx + position.dx - _positionStart.dx).toInt().abs() > 20 ||
        (pos.dy + position.dy - _positionStart.dy).toInt().abs() > 20) {
      //await settingsApp.safeToDisk();
    }
  }
}
