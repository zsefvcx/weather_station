import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/home_page.dart';

class WeatherAppStation extends StatelessWidget {
  final StackDataEnvironmentalConditions _stackDEC;

  const WeatherAppStation({
    required StackDataEnvironmentalConditions stackDEC,
    super.key
  }) : _stackDEC = stackDEC;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StackDataEnvironmentalConditions>(
            create: (_) => _stackDEC
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(title: 'Weather Station'.hardcoded),
      ),
    );
  }
}
