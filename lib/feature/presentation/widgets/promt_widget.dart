import 'package:flutter/material.dart';

class PromtWidget extends StatelessWidget {
  const PromtWidget({
    required String prompt,
    super.key,
  }) : _prompt = prompt;

  final String _prompt;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Text(_prompt, style: const TextStyle(color: Colors.white))
    );
  }
}
