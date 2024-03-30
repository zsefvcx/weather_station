
import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class CustomSliderWidget extends StatelessWidget {
  const CustomSliderWidget({
    required String text,
    required double value,
    required Future<dynamic> Function(double value)? onChanged,
    required IconData icon,
    super.key,
    FocusNode? focusNode,
    FocusNode? focusNodeNext,
    double min = 0.5,
    double max = 1,
    int? divisions = 20,
    double heightContainer = 60,
    Color activeColor = AppColors.red,
    Color inactiveColor = AppColors.blue,
    Color beakGroundColor = AppColors.grey,
  })  : _text = text,
        _icon = icon,
        _min = min,
        _max = max,
        _value = value,
        _heightContainer = heightContainer,
        _onChanged = onChanged,
        _divisions = divisions,
        _activeColor = activeColor,
        _inactiveColor = inactiveColor,
        _beakGroundColor = beakGroundColor,
        _focusNode = focusNode,
        _focusNodeNext = focusNodeNext;

  final String _text;
  final double _min;
  final double _max;
  final double _value;
  final Color _activeColor;
  final Color _inactiveColor;
  final Color _beakGroundColor;
  final IconData _icon;
  final int? _divisions;
  final double _heightContainer;
  final FocusNode? _focusNode;
  final FocusNode? _focusNodeNext;
  final Future<dynamic> Function(double)? _onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _beakGroundColor,
      margin: const EdgeInsets.all(5),
      elevation: 10,
      child: Container(
        height: _heightContainer,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomIcon(_icon,),
                  10.w,
                  CustomTextWidget(_text),
                ],
              ),
            ),
            Expanded(
              child: Slider(
                focusNode: _focusNode,
                value: _value,
                label: '$_value',
                divisions: _divisions,
                min: _min,
                max: _max,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onChangeEnd: (value) {
                  _focusNodeNext?.requestFocus();
                },
                onChanged: _onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
