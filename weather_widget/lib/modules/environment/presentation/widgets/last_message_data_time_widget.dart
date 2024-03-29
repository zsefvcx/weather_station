
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class LastMessageDataTime extends StatelessWidget {
  const LastMessageDataTime({
    required DateTime dateTime,
    super.key,
  }): _dateTime = dateTime;

  final DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      'lm: ${DateFormat('kk:mm').format(_dateTime)}'.hrd,
      fontSize: AppFonts.fontSizeLite,
    );
  }
}
