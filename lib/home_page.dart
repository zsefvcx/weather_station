import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

GlobalKey globalKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({required String title, super.key}) : _title = title;

  final String _title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final stackDEC = context.watch<StackDataEnvironmentalConditions>();
    final stackDOW = context.watch<StackDataOpenWeather>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget._title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(stackDOW.length>0)Card(child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Text('${stackDOW.last}'.hardcoded),
              )),
              if(stackDEC.length>0)Card(child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Text('${stackDEC.last}'.hardcoded),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Text('History:'.hardcoded),
              ),
              Expanded(
                child: ListView.builder(
                  key: globalKey,
                  controller: ScrollController(),
                  itemCount: stackDEC.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Center(
                          child: Text('$index:${stackDEC.elementAt(index).toJson()}',
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //
      //   },
      //   tooltip: 'Get',
      //   child: const Icon(Icons.get_app_outlined),
      // ),
    );
  }
}
