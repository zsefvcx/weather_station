import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class CustomMainBarWin extends StatelessWidget {
  const CustomMainBarWin({
    required String title,
    required Future<void> Function() action,
    required IconData iconAction,
    required String textAction,
    double height = 25,
    super.key,

    Color? color = AppColors.black,
  })  : _height = height,
        _title = title,
        _color = color,
        _action = action,
        _iconAction = iconAction,
        _textAction = textAction;

  final double _height;
  final String _title;
  final Color? _color;

  final Future<void> Function() _action;
  final IconData _iconAction;
  final String _textAction;



  @override
  Widget build(BuildContext context) {
    final changePositionAction = ChangePositionAction(context: context);
    final mainButtonAction = MainButtonAction(context: context);
    final settingsApp = Provider.of<Settings>(context, listen: false);
    final actions = <({
      Future<dynamic> Function() function,
      IconData icon,
      IconData? icon2,
      String tooltip,
      bool? iconActoin,
    })>{
      (
        function: _action,
        icon: _iconAction,
        icon2: null,
        tooltip: _textAction,
        iconActoin: null,
      ),
      (
        function: mainButtonAction.pinWindows,
        icon: Icons.check_box_outline_blank,
        icon2: Icons.library_add_check_outlined,
        tooltip: 'Pin'.hrd,
        iconActoin: settingsApp.floatOnTop,
      ),
      (
        function: mainButtonAction.restart,
        icon: Icons.restart_alt,
        icon2: null,
        tooltip: 'Restart'.hrd,
        iconActoin: null,
      ),
      (
        function: mainButtonAction.minimize,
        icon: Icons.minimize,
        icon2: null,
        tooltip: 'Minimize'.hrd,
        iconActoin: null,
      ),
      (
        function: mainButtonAction.close,
        icon: Icons.close,
        icon2: null,
        tooltip: 'Close'.hrd,
        iconActoin: null,
      ),
    };

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanStart: changePositionAction.onPanStart,
      onPanUpdate: changePositionAction.onPanUpdate,
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: Container(
          color: _color,
          height: _height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              10.w,
              if (size.width > Constants.sizeLiteDouble.width)
                Expanded(child: CustomTextWidget(_title)),
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...actions.map((e) => Expanded(
                          child: CustomIconButton(
                            e.icon,
                            icon2: e.icon2,
                            onPressed: e.function,
                            tooltip: e.tooltip,
                            startStatus: e.iconActoin??false,
                          ),
                        )),
                  ],
                ),
              ),
              10.w,
            ],
          ),
        ),
      ),
    );
  }
}
