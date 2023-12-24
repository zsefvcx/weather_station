import 'package:flutter/material.dart';

class PromtWidget extends StatelessWidget {
  const PromtWidget({
    required String prompt,
    required Color textColor,
    required bool transparent,
    super.key,
  }) : _prompt = prompt,
       _textColor = textColor,
       _transparent = transparent;

  final bool  _transparent;
  final Color  _textColor;
  final String _prompt;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: _transparent?Colors.transparent:Colors.white,
        child: Text(_prompt, style: TextStyle(color: _textColor))
    );
  }
}
