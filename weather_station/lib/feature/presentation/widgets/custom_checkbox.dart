
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required void Function(bool?)? onChanged,
    required String text,
    required bool value,
    super.key,
  }) : _value = value,
       _onChanged = onChanged,
       _text = text;

  final bool _value;
  final String _text;


  final void Function(bool?)? _onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 30,
      child: Row(
        children: [
          Text(_text),
          Checkbox(
            checkColor: Colors.white,
            value: _value,
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
