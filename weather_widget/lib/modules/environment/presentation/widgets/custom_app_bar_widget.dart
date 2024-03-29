import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class CustomMainBarWin extends StatelessWidget {
  const CustomMainBarWin({
    required String title,
    required Future<void> Function() action,
    required IconData iconAction,
    required String textAction,
    super.key,
    double height = 25,
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
    final changePosition = ChangePosition(context: context);
    final mainButtonAction = MainButtonAction(context: context);
    final actions = <({
      Future<dynamic> Function() function,
      IconData icon,
      IconData? icon2,
      String tooltip,
    })>{
      (
        function: _action,
        icon: _iconAction,
        icon2: null,
        tooltip: _textAction,
      ),
      (
        function: mainButtonAction.pinWindows,
        icon: Icons.check_box_outline_blank,
        icon2: Icons.library_add_check_outlined,
        tooltip: 'Pin'.hrd
      ),
      (
        function: mainButtonAction.restart,
        icon: Icons.restart_alt,
        icon2: null,
        tooltip: 'Restart'.hrd
      ),
      (
        function: mainButtonAction.minimize,
        icon: Icons.minimize,
        icon2: null,
        tooltip: 'Minimize'.hrd
      ),
      (
        function: mainButtonAction.close,
        icon: Icons.close,
        icon2: null,
        tooltip: 'Close'.hrd),
    };

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanStart: changePosition.onPanStart,
      onPanUpdate: changePosition.onPanUpdate,
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
