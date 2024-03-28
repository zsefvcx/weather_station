
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(IconData? icon, {
    super.key,
    IconData? icon2,
    String? tooltip,
    Color? color = Colors.white,
    Future<dynamic> Function()? onPressed,
    bool secondIcon = false,
  }) : _onPressed = onPressed,
       _tooltip = tooltip,
       _color = color,
       _icon = icon,
       _icon2 = icon2,
       _secondIcon = secondIcon;

  final IconData? _icon;
  final IconData? _icon2;
  final String? _tooltip;
  final Color? _color;
  final Future<dynamic> Function()? _onPressed;
  final bool _secondIcon;

  @override
  Widget build(BuildContext context) {
    final valueNotifierPinAction = ValueNotifier<bool>(_secondIcon);

    return IconButton(onPressed: () async {
      final result = await _onPressed?.call();
      if (result is bool){
        valueNotifierPinAction.value = result;
      }
    },
      icon: ValueListenableBuilder<bool>(
          valueListenable: valueNotifierPinAction,
          builder: (_, value, __) {
            return Icon(
              !value?_icon:_icon2,
              size: 7,
              color: _color,
              opticalSize: 7,
            );
          }
      ),
      tooltip: _tooltip,
    );
  }
}
