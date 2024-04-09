import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon(IconData? icon, {
    super.key,
    IconData? icon2,
    Color? color = AppColors.white,
    double size = AppTheme.iconSize,
  }) : _icon = icon, _icon2 = icon2, _color = color, _size = size;

  final IconData? _icon;
  final IconData? _icon2;
  final Color? _color;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _size*2,
      width: _size*2,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.all(Radius.circular(_size)),
      ),
      child: Center(
        child: Stack(
          children: [
            Icon(_icon,  size: _size, color: _color,),
            Visibility(
              visible: _icon2!=null,
              child: Icon(_icon2, size: _size, color: _color,),
            ),
        ]),
      ),
    );
  }
}
