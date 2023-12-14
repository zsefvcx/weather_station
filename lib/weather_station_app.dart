import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/home_page.dart';

class WeatherAppStation extends StatelessWidget {
  final StackDataEnvironmentalConditions _stackDEC;
  final StackDataOpenWeather _stackDOW;

  const WeatherAppStation({
    required StackDataEnvironmentalConditions stackDEC,
    required StackDataOpenWeather stackDOW,
    super.key
  }) : _stackDEC = stackDEC, _stackDOW = stackDOW;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StackDataEnvironmentalConditions>(
            create: (_) => _stackDEC
        ),
        ChangeNotifierProvider<StackDataOpenWeather>(
            create: (_) => _stackDOW
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather widget',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TwoPane(
          startPane: const Placeholder(),
          endPane: HomePage(title: 'Weather Station'.hardcoded),
          paneProportion: 0.3,
          panePriority: MediaQuery.of(context).size.width > 500 ? TwoPanePriority.both : TwoPanePriority.start,
        ),
      ),
    );
  }
}
