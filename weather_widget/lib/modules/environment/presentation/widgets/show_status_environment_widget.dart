import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ShowSingleSensor(
                  name: !_data.errorExt?'Int':null,
                  temp: _data.tempInt,
                  humidity: _data.humidityInt,
                ),
              ),
              Visibility(
                visible: !_data.errorExt,
                child: Expanded(
                  child: ShowSingleSensor(
                    name: 'Ext',
                    temp: _data.tempExt,
                    humidity: _data.humidityExt,
                  ),
                ),
              ),
            ],
          ),
          CustomTextWidget('${_data.pressure ?? '--'} mmHg'),
        ],
      );
  }
}
