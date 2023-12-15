import 'package:flutter/material.dart';
import 'package:weather_station/core/data/current_date_time.dart';

class ShowDateTime extends StatelessWidget {
  const ShowDateTime({
    required this.currentDateTime,
    super.key,
  });

  final CurrentDateTime? currentDateTime;

  @override
  Widget build(BuildContext context) {
    final hour = currentDateTime?.dataTime.hour??0;
    final minute = currentDateTime?.dataTime.minute??0;
    return Visibility(
      visible: currentDateTime != null,
      child: Text('${hour<10?'0$hour':'$hour'}:${minute<10?'0$minute':'$minute'}'),
    );
  }
}
