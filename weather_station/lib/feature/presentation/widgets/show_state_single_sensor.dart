
import 'package:flutter/material.dart';
import 'package:weather_station/feature/presentation/presentation.dart';

class ShowStateSingleSensor extends StatelessWidget {
  const ShowStateSingleSensor({
    required SensorStatus sensorStatus,
    required Color color,
    super.key,
  })  : _sensorStatus = sensorStatus,
        _color = color;

  final SensorStatus _sensorStatus;
  final Color _color;


  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: _color,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_sensorStatus.typeSensor, style: style),
        Text('\t${_sensorStatus.temp} ˚C,\t${_sensorStatus.humid} %', style: style),
        if(_sensorStatus.press != null)
          Text(',\t${_sensorStatus.press} mmHg', style: style),
      ],
    );
  }
}
