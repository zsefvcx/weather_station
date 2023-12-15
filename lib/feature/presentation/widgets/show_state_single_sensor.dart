
import 'package:flutter/material.dart';
import 'package:weather_station/common/common.dart';

import 'package:weather_station/feature/presentation/presentation.dart';

class ShowStateSingleSensor extends StatelessWidget {
  const ShowStateSingleSensor({
    required SensorStatus sensorStatus,
    super.key,
  })  : _sensorStatus = sensorStatus;

final SensorStatus _sensorStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Row(//FittedBox
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_sensorStatus.typeSensor),
          Text('\t${_sensorStatus.temp} ˚C,\t${_sensorStatus.humid} %'),
          if(_sensorStatus.press != null)
            Text(',\t${_sensorStatus.press} mmHg',),
        ],
      ),
    );
  }
}
