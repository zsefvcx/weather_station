
import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(IconData? icon, {
    super.key,
    IconData? icon2,
    String? tooltip,
    Color? color = AppColors.white,
    double size = AppTheme.iconSizeLite,
    Future<dynamic> Function()? onPressed,
    bool startStatus = false,
  }) : _onPressed = onPressed,
       _tooltip = tooltip,
       _color = color,
       _icon = icon,
       _icon2 = icon2,
       _startStatus = startStatus,
       _size = size;

  final IconData? _icon;
  final IconData? _icon2;
  final String? _tooltip;
  final Color? _color;
  final Future<dynamic> Function()? _onPressed;
  final bool _startStatus;
  final double _size;

  @override
  Widget build(BuildContext context) {
    final valueNotifierPinAction = ValueNotifier<bool>(_startStatus);

    return IconButton(onPressed: () async {
      final result = await _onPressed?.call();
      if (result is bool){
        valueNotifierPinAction.value = result;
      }
    },
      icon: ValueListenableBuilder<bool>(
          valueListenable: valueNotifierPinAction,
          builder: (_, value, __) {
            return CustomIcon(
              !value?_icon:_icon2,
              size: _size,
              color: _color,
            );
          }
      ),
      tooltip: _tooltip,
    );
  }
}
