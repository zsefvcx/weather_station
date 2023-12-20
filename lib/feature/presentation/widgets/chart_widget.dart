import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';


class ChartWidget extends StatefulWidget {

  const ChartWidget({
    required double height,
    super.key,
  }) : _height = height;

  final double _height;

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
    final data = listDataValue.toSet;
    final minX = listDataValue.minX?.toDouble()??0;
    final minY = _isCheckedTemperature1?
    listDataValue.minYT?.toDouble()??0:_isCheckedAirHumidity2?
    listDataValue.minYH?.toDouble()??0:
    listDataValue.minYP?.toDouble()??650;
    final maxX = listDataValue.maxX?.toDouble()??60*60*24;
    final maxY = _isCheckedTemperature1?
    listDataValue.maxYT?.toDouble()??0:_isCheckedAirHumidity2?
    listDataValue.maxYH?.toDouble()??10:
    listDataValue.maxYP?.toDouble()??850;
    return Column(children: [
      SizedBox(
        height: widget._height,
        width: double.infinity,

        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 0.85,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 25, left: 25,
                  top: 25, bottom: 25,
                ),
                child: LineChart(
                  LineChartData(
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipBorder: BorderSide(),
                        tooltipRoundedRadius: 10,
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                          spots: [
                            for(final point in data)
                              flSpoEx(
                                  _isCheckedTemperature1?
                                  point.t1:_isCheckedAirHumidity2?
                                  point.h1:
                                  point.p1, point.time)
                          ],
                          isCurved: true,
                          barWidth: 1,
                          color: Constants.internalColor,
                      ),
                      LineChartBarData(
                        spots: [
                          for(final point in data)
                            flSpoEx(
                                 _isCheckedTemperature1?
                                 point.t2:_isCheckedAirHumidity2?
                                 point.h2:
                                 point.p2, point.time)
                        ],
                        isCurved: true,
                        barWidth: 1,
                        color: Constants.externalColor,
                      ),
                      LineChartBarData(
                        spots: [
                          for(final point in data)
                            flSpoEx(
                                 _isCheckedTemperature1?
                                 point.t3:_isCheckedAirHumidity2?
                                 point.h3:
                                 point.p3, point.time)
                        ],
                          isCurved: true,
                          barWidth: 1,
                          color: Constants.forcastColor,
                      ),
                    ],
                    // borderData: FlBorderData(
                    //     border: const Border(bottom: BorderSide(), left: BorderSide())),

                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: SideTitles(
                        showTitles: true,
                        interval: listDataValue.intervalX?.toDouble()??60*60*4,
                        getTitlesWidget: (value, meta) {
                          final h = value.toInt()~/(60*60);
                          final m = value.toInt()~/(60) - h*60;
                          final result = '${h<10?'0$h':h}:${m<10?'0$m':m} ';
                          if(value == minX || value == maxX){
                            return const Text('');
                          }
                          return Text(result, style: const TextStyle(
                            fontSize: 10
                          ),);
                        },

                      )),
                      topTitles: AxisTitles(
                        axisNameSize: 25,
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(_isCheckedTemperature1
                              ? 'Temperature, °C'
                              : (_isCheckedAirHumidity2
                              ? 'Humidity, %'
                              : 'Pressure, mmHg')),
                        )
                      ),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(sideTitles: SideTitles(
                        showTitles: true,
                        interval: _isCheckedTemperature1?
                        listDataValue.intervalYT?.toDouble():
                        _isCheckedAirHumidity2?
                        listDataValue.intervalYH?.toDouble():
                        listDataValue.intervalYP?.toDouble()
                        ,
                        getTitlesWidget: (value, meta) {
                          if(value == minY || value == maxY){
                            return const Text('');
                          }
                          return Text(value.toInt().toString(), style: const TextStyle(
                            fontSize: 10
                        ),);
                        },
                      )),
                    ),
                    minY: minY,
                    maxY: maxY,
                    minX: minX,
                    maxX: maxX,

                  ),

                ),
              ),
            ),
          ],
        ),
      ),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
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
          IconButton(onPressed: (){
            setState(() {

            });
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
    ]);
  }

  FlSpot flSpoEx(num? value, DateTime dateTime) {
    final dTime = dateTime.second +     dateTime.minute*60 +
                  dateTime.hour*60*60;

    return value!=null?FlSpot(dTime.toDouble(), value.toDouble()):FlSpot.nullSpot;
  }

}
