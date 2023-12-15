import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/core/core.dart';

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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget._title),
                if (currentDateTime != null)
                  Text('${currentDateTime?.dataTime.hour}'
                      ':${currentDateTime?.dataTime.minute}'),
              ],
            ),
          ),
        ),
        body: const Placeholder());
  }
}
