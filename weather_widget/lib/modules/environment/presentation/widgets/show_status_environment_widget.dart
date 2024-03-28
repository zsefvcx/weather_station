import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_widget/modules/environment/domain/entities/environment_data_entity.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class ShowStatusEnvironmentWidget extends StatelessWidget {
  const ShowStatusEnvironmentWidget({
    required EnvironmentDataEntity data,
    super.key,
  }) : _data = data;

  final EnvironmentDataEntity _data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShowSingleSensor(
                  name: 'Int',
                  temp: _data.tempInt,
                  humidity: _data.humidityInt ,
                ),
                ShowSingleSensor(
                  name: 'Ext',
                  temp: _data.tempExt,
                  humidity: _data.humidityExt,
                ),
              ],
            ),
            CustomTextWidget('${_data.pressure??'--'} mmHg'),
          ],
        ),
      ),

    );
  }
}
