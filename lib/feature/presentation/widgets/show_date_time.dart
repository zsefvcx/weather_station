import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/core/timer/current_date_time.dart';

class ShowDateTime extends StatefulWidget {
  const ShowDateTime({
    super.key,
  });


  @override
  State<ShowDateTime> createState() => _ShowDateTimeState();
}

class _ShowDateTimeState extends State<ShowDateTime> {
  CurrentDateTime? currentDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    currentDateTime?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentDateTime = context.watch<CurrentDateTime>();
    final hour = currentDateTime?.dataTime.hour??0;
    final minute = currentDateTime?.dataTime.minute??0;
    return Visibility(
      visible: currentDateTime != null,
      child: Text('${hour<10?'0$hour':'$hour'}:${minute<10?'0$minute':'$minute'}'),
    );
  }
}
