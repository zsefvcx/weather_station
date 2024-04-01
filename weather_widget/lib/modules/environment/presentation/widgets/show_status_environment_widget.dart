import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/entities/environment_data_entity.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';
import 'package:window_manager/window_manager.dart';

class ShowStatusEnvironmentWidget extends StatelessWidget {
  const ShowStatusEnvironmentWidget({
    required EnvironmentDataEntity data,
    super.key,
  }) : _data = data;

  final EnvironmentDataEntity _data;

  @override
  Widget build(BuildContext context) {
    final settingsApp = Provider.of<Settings>(context, listen: false);
    if(!_data.errorExt) {
      windowManager.setSize(Constants.sizeLiteDouble);
      if (settingsApp.iDouble == 1){
        settingsApp..iDouble = 2
        ..safeToDisk();
      }
    } else {
      windowManager.setSize(Constants.sizeLite);
      if (settingsApp.iDouble == 2){
        settingsApp..iDouble = 1
          ..safeToDisk();
      }
    }
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
