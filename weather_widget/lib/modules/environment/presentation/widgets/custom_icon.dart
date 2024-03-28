import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon(IconData icon, {
    super.key,
    IconData? icon2,
  }) : _icon = icon, _icon2 = icon2;

  final IconData? _icon;
  final IconData? _icon2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(_icon,  size: 14, color: Colors.black, opticalSize: 14,),
        Visibility(
          visible: _icon2!=null,
          child: Icon(_icon2, size: 14, color: Colors.black, opticalSize: 14,),
        ),
    ]);
  }
}
