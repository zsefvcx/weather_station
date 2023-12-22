import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/feature/presentation/presentation.dart';
import 'package:weather_station/home_page.dart';

class WeatherAppStation extends StatelessWidget {
  final StackDataEnvironmentalConditions _stackDEC;
  final StackDataOpenWeather _stackDOW;
  final StackChartDataValue _stackCDV;
  final CurrentDateTime _currentDateTime;
  final NetworkInfo _networkInfo;

  const WeatherAppStation({
    required StackDataEnvironmentalConditions stackDEC,
    required StackDataOpenWeather stackDOW,
    required StackChartDataValue stackCDV,
    required CurrentDateTime currentDateTime,
    required NetworkInfo networkInfo,
    super.key
    }): _stackDEC = stackDEC,
        _stackDOW = stackDOW,
        _stackCDV = stackCDV,
        _currentDateTime = currentDateTime,
        _networkInfo = networkInfo;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StackDataEnvironmentalConditions>(
            create: (_) => _stackDEC),
        ChangeNotifierProvider<StackDataOpenWeather>(create: (_) => _stackDOW),
        ChangeNotifierProvider<StackChartDataValue>(create: (_) => _stackCDV),
        ChangeNotifierProvider<CurrentDateTime>(
            create: (_) => _currentDateTime),
        ChangeNotifierProvider<NetworkInfo>(
            create: (_) => _networkInfo),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather widget',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TwoPane(
          startPane: MainPage(title: 'Weather Station'.hardcoded),
          endPane: HomePage(title: 'Weather Station Logger'.hardcoded),
          paneProportion: 0.3,
          panePriority: MediaQuery.of(context).size.width > 500
              ? TwoPanePriority.both
              : TwoPanePriority.start,
        ),
      ),
    );
  }
}
