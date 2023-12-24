import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/common/common.dart';
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


  @override
  Widget build(BuildContext context) {

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
                const ShowDateTime(),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(stackDOW.isNotEmpty)ShowWidgetWithPrompt(
                  prompt: 'Weather Forecast',
                  textColor: Colors.black,
                  transparent: false,
                  child: ShowStateSingleSensor(
                    sensorStatus: SensorStatus(
                    numberWidget: 1,
                    typeSensor: 'Frc',
                    temp: stackDOW.last.mainStatus?.temp??-255,
                    humid: stackDOW.last.mainStatus?.humidity??-255,
                    press: stackDOW.last.mainStatus?.pressure??-255,),
                    color: Constants.forcastColor,
                  ),
                ),
                if(stackDEC.isNotEmpty)ShowWidgetWithPrompt(
                  prompt: 'Room Temperature',
                  textColor: Colors.black,
                  transparent: false,
                  child: ShowStateSingleSensor(
                    sensorStatus: SensorStatus(
                    numberWidget: 2,
                    typeSensor: 'Int',
                    temp: stackDEC.last.temperature,
                    humid: stackDEC.last.humidity,
                    press: stackDEC.last.pressure,),
                    color: Constants.internalColor,
                  ),
                ),
                if(stackDEC.isNotEmpty)ShowWidgetWithPrompt(
                  prompt: 'Outdoor temperature',
                  textColor: Colors.black,
                  transparent: false,
                  child: ShowStateSingleSensor(
                    sensorStatus: SensorStatus(
                    numberWidget: 3,
                    typeSensor: 'Ext',
                    temp: stackDEC.last.temperature2,
                    humid: stackDEC.last.humidity2,),
                    color: Constants.externalColor,
                  ),
                ),
                const Expanded(
                  child: ChartWidget(
                    height: 450,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BottomAppBar(
          color: Theme.of(context).colorScheme.inversePrimary,
          height: Theme.of(context).appBarTheme.toolbarHeight,
          child: const Row(
            children: [
              ShowDateTime(),
              ShowStatusConnection(),
            ],
          ),
        ),
    );
  }
}
