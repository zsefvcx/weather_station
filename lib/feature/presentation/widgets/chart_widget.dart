// // ignore_for_file: avoid_print
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// class ChartWidget extends StatefulWidget {
//
//   const ChartWidget({
//     required double height,
//     Key? key,
//   })  : _height = height,
//         super(key: key);
//
//   final double _height;
//
//   @override
//   State<ChartWidget> createState() => _ChartWidgetState();
// }
//
// class _ChartWidgetState extends State<ChartWidget> {
//   bool _isCheckedTemperature1 = true;
//   bool _isCheckedAirHumidity2 = false;
//   bool _isCheckedPressure3 = false;
//
//   @override
//   Widget build(BuildContext context) {
//     List<DataValue> listDataValue = Provider.of<List<DataValue>>(context);
//
//     EnvConditions evnState = context.watch<EnvConditions>();
//
//     return Column(children: [
//       SizedBox(
//         height: widget._height,
//         width: double.infinity,
//
//         child: SfCartesianChart(
//             trackballBehavior: TrackballBehavior(
//                 enable: true,
//                 markerSettings: const TrackballMarkerSettings(
//                   height: 10,
//                   width: 10,
//                   borderWidth: 4,
//                 ),
//                 activationMode: ActivationMode.singleTap,
//                 tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                 tooltipAlignment: ChartAlignment.near),
//             margin: const EdgeInsets.all(10),
//             borderWidth: 0,
//             plotAreaBorderWidth: 0,
//             isTransposed: false,
//             primaryXAxis: DateTimeAxis(
//                 majorTickLines: const MajorTickLines(
//                     width: 0),
//                 dateFormat: DateFormat.Hm(),
//                 labelStyle: widget._textStyle),
//             primaryYAxis: NumericAxis(
//                 maximum: _isCheckedAirHumidity2
//                     ? 100
//                     : _isCheckedPressure3
//                         ? 790
//                         : null,
//                 minimum: _isCheckedAirHumidity2
//                     ? 0
//                     : _isCheckedPressure3
//                         ? 720
//                         : null,
//                 interval: _isCheckedAirHumidity2
//                     ? 10
//                     : _isCheckedPressure3
//                         ? 10
//                         : null,
//                 labelFormat: '{value}'),
//             title: ChartTitle(
//                 text: _isCheckedTemperature1
//                     ? 'Temperature, °C'
//                     : (_isCheckedAirHumidity2
//                         ? 'Humidity, %'
//                         : 'Pressure, mmHg'),
//                 textStyle: widget._textStyle),
//             enableAxisAnimation: false,
//             zoomPanBehavior: ZoomPanBehavior(
//               enableMouseWheelZooming: true,
//             ),
//             series: <ChartSeries<DataValue, DateTime>>[
//                 LineSeries<DataValue, DateTime>(
//                     name: '1',
//                     color: SettingsApp.color[1],
//                     dataSource: listDataValue,
//                     xValueMapper: (DataValue victims, _) => victims.time,
//                     yValueMapper: (DataValue victims, _) =>
//                     _isCheckedTemperature1
//                         ? victims.t3: (_isCheckedAirHumidity2? victims.h3
//                         : victims.p3),
//                     animationDuration: 0,
//                     markerSettings: const MarkerSettings(
//                         height: 2,
//                         width: 2,
//                         isVisible: true,
//                         shape: DataMarkerType.circle,
//                         color: Colors.green),
//                     // Enable data label
//                     dataLabelSettings:
//                     const DataLabelSettings(isVisible: false)),
//               LineSeries<DataValue, DateTime>(
//                   name: '2',
//                   color: SettingsApp.color[2],
//                   dataSource: listDataValue,
//                   xValueMapper: (DataValue victims, _) => victims.time,
//                   yValueMapper: (DataValue victims, _) => _isCheckedTemperature1
//                       ? victims.t1
//                       : (_isCheckedAirHumidity2
//                           ? victims.t2
//                           : victims.p1),
//                   animationDuration: 0,
//                   markerSettings: const MarkerSettings(
//                       height: 2,
//                       width: 2,
//                       isVisible: true,
//                       shape: DataMarkerType.circle,
//                       color: Colors.green),
//                   dataLabelSettings: const DataLabelSettings(isVisible: false)),
//               //if (_isCheckedPressure3 == false)
//                 LineSeries<DataValue, DateTime>(
//                     name: '3',
//                     color: SettingsApp.color[3],
//                     dataSource: listDataValue,
//                     xValueMapper: (DataValue victims, _) => victims.time,
//                     yValueMapper: (DataValue victims, _) =>
//                         _isCheckedTemperature1
//                             ? victims.h1
//                             : victims.h2,
//                     animationDuration: 0,
//                     markerSettings: const MarkerSettings(
//                         height: 2,
//                         width: 2,
//                         isVisible: true,
//                         shape: DataMarkerType.circle,
//                         color: Colors.green),
//                     // Enable data label
//                     dataLabelSettings:
//                         const DataLabelSettings(isVisible: false)),
//             ]),
//       ),
//       Wrap(
//         runSpacing: 10,
//         spacing: 10,
//         children: [
//           SizedBox(
//             width: 80,
//             height: 30,
//             child: Row(
//               children: [
//                 const Text('\t T: '),
//                 Checkbox(
//                   checkColor: Colors.white,
//                   value: _isCheckedTemperature1,
//                   onChanged: (value) {
//                     setState(() {
//                       _isCheckedTemperature1 = true;
//                       _isCheckedAirHumidity2 = false;
//                       _isCheckedPressure3 = false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 80,
//             height: 30,
//             child: Row(
//               children: [
//                 const Text('\t H: '),
//                 Checkbox(
//                   checkColor: Colors.white,
//                   value: _isCheckedAirHumidity2,
//                   onChanged: (value) {
//                     setState(() {
//                       _isCheckedTemperature1 = false;
//                       _isCheckedAirHumidity2 = true;
//                       _isCheckedPressure3 = false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//             SizedBox(
//               width: 80,
//               height: 30,
//               child: Row(
//                 children: [
//                   const Text('\t P: '),
//                   Checkbox(
//                     checkColor: Colors.white,
//                     value: _isCheckedPressure3,
//                     onChanged: (value) {
//                       setState(() {
//                         _isCheckedTemperature1 = false;
//                         _isCheckedAirHumidity2 = false;
//                         _isCheckedPressure3 = true;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     ]);
//   }
// }
