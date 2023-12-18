// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';


class ChartWidget extends StatefulWidget {

  const ChartWidget({
    super.key,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  bool _isCheckedTemperature1 = true;
  bool _isCheckedAirHumidity2 = false;
  bool _isCheckedPressure3 = false;

  @override
  Widget build(BuildContext context) {
    final listDataValue = context.watch<StackChartDataValue>();

    return Column(children: [
      SizedBox(
        //height: widget._height,
        width: double.infinity,

        child: SfCartesianChart(
            trackballBehavior: TrackballBehavior(
                enable: true,
                markerSettings: const TrackballMarkerSettings(
                  height: 10,
                  width: 10,
                  borderWidth: 4,
                ),
                activationMode: ActivationMode.singleTap,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                tooltipAlignment: ChartAlignment.near),
            plotAreaBorderWidth: 0,
            primaryXAxis: const DateTimeAxis(
                majorTickLines: MajorTickLines(
                    width: 0)),
            primaryYAxis: NumericAxis(
                maximum: _isCheckedAirHumidity2
                    ? 100
                    : _isCheckedPressure3
                        ? 790
                        : 45,
                minimum: _isCheckedAirHumidity2
                    ? 0
                    : _isCheckedPressure3
                        ? 720
                        : -45,
                interval: 10,
                labelFormat: '{value}'),
            title: ChartTitle(
                text: _isCheckedTemperature1
                    ? 'Temperature, °C'
                    : (_isCheckedAirHumidity2
                        ? 'Humidity, %'
                        : 'Pressure, mmHg')),
            zoomPanBehavior: ZoomPanBehavior(
              enableMouseWheelZooming: true,
            ),
            series: <CartesianSeries<ChartDataValue, DateTime>>[
                LineSeries<ChartDataValue, DateTime>(
                    name: '1',
                    color: Settings.color[1],
                    dataSource: listDataValue.toList,
                    xValueMapper: (victims, _) => victims.time,
                    yValueMapper: (victims, _) {
                      if(_isCheckedTemperature1){
                        return victims.t1;
                      }
                      if(_isCheckedAirHumidity2){
                        return victims.h1;
                      }
                      if(_isCheckedPressure3){
                        return victims.p1;
                      }
                      throw UnimplementedError();
                    },
                    animationDuration: 0,
                    markerSettings: const MarkerSettings(
                        height: 2,
                        width: 2,
                        isVisible: true,
                        color: Colors.green)),
                LineSeries<ChartDataValue, DateTime>(
                    name: '2',
                    color: Settings.color[2],
                    dataSource: listDataValue.toList,
                    xValueMapper: (victims, _) => victims.time,
                    yValueMapper: (victims, _) {
                      if(_isCheckedTemperature1){
                        return victims.t2;
                      }
                      if(_isCheckedAirHumidity2){
                        return victims.h2;
                      }
                      if(_isCheckedPressure3){
                        return victims.p2;
                      }
                      throw UnimplementedError();
                    },
                    animationDuration: 0,
                    markerSettings: const MarkerSettings(
                        height: 2,
                        width: 2,
                        isVisible: true,
                        color: Colors.green)),
                LineSeries<ChartDataValue, DateTime>(
                      name: '3',
                      color: Settings.color[3],
                      dataSource: listDataValue.toList,
                      xValueMapper: (victims, _) => victims.time,
                      yValueMapper: (victims, _) {
                        if(_isCheckedTemperature1){
                          return victims.t3;
                        }
                        if(_isCheckedAirHumidity2){
                          return victims.h3;
                        }
                        if(_isCheckedPressure3){
                          return victims.p3;
                        }
                        throw UnimplementedError();
                      },
                      animationDuration: 0,
                      markerSettings: const MarkerSettings(
                          height: 2,
                          width: 2,
                          isVisible: true,
                          color: Colors.green)),
            ]
        ),
      ),
      Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          SizedBox(
            width: 80,
            height: 30,
            child: Row(
              children: [
                const Text('\t T: '),
                Checkbox(
                  checkColor: Colors.white,
                  value: _isCheckedTemperature1,
                  onChanged: (value) {
                    setState(() {
                      _isCheckedTemperature1 = true;
                      _isCheckedAirHumidity2 = false;
                      _isCheckedPressure3 = false;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: Row(
              children: [
                const Text('\t H: '),
                Checkbox(
                  checkColor: Colors.white,
                  value: _isCheckedAirHumidity2,
                  onChanged: (value) {
                    setState(() {
                      _isCheckedTemperature1 = false;
                      _isCheckedAirHumidity2 = true;
                      _isCheckedPressure3 = false;
                    });
                  },
                ),
              ],
            ),
          ),
            SizedBox(
              width: 80,
              height: 30,
              child: Row(
                children: [
                  const Text('\t P: '),
                  Checkbox(
                    checkColor: Colors.white,
                    value: _isCheckedPressure3,
                    onChanged: (value) {
                      setState(() {
                        _isCheckedTemperature1 = false;
                        _isCheckedAirHumidity2 = false;
                        _isCheckedPressure3 = true;
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    ]);
  }
}
