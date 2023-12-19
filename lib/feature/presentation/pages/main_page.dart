import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/feature/presentation/presentation.dart';
import 'package:weather_station/feature/presentation/widgets/chart_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    required String title,
    super.key,
  }) : _title = title;

  final String _title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    final stackDEC = context.watch<StackDataEnvironmentalConditions>();
    final stackDOW = context.watch<StackDataOpenWeather>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget._title),
                  ShowDateTime(currentDateTime: currentDateTime),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if(stackDOW.isNotEmpty)ShowStateSingleSensor(
                sensorStatus: SensorStatus(
                numberWidget: 1,
                typeSensor: 'Forecast',
                temp: stackDOW.last.mainStatus?.temp??-255,
                humid: stackDOW.last.mainStatus?.humidity??-255,
                press: stackDOW.last.mainStatus?.pressure??-255,),
              ),
              if(stackDEC.isNotEmpty)ShowStateSingleSensor(
                sensorStatus: SensorStatus(
                numberWidget: 2,
                typeSensor: 'Internal',
                temp: stackDEC.last.temperature,
                humid: stackDEC.last.humidity,
                press: stackDEC.last.pressure,),
              ),
              if(stackDEC.isNotEmpty)ShowStateSingleSensor(
                sensorStatus: SensorStatus(
                numberWidget: 3,
                typeSensor: 'External',
                temp: stackDEC.last.temperature2,
                humid: stackDEC.last.humidity2,),
              ),
              const Expanded(
                child: ChartWidget(
                  height: 450,
                ),
              ),
            ],
          ),
        )
    );
  }
}
