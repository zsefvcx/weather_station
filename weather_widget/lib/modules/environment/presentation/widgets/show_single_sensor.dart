import 'package:flutter/material.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';

class ShowSingleSensor extends StatelessWidget {
  const ShowSingleSensor({
    super.key,
    String? name,
    num? temp,
    num? humidity,
  }) : _name = name, _temp = temp, _humidity = humidity;

  final String? _name;
  final num? _temp;
  final num? _humidity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(_name??''),
          CustomTextWidget('${_temp??'--'} °C'),
          CustomTextWidget('${_humidity??'--'} %'),
        ],
      ),
    );
  }
}
