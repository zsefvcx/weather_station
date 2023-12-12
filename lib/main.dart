import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weather_station/core/core.dart';


void main() {
  Future<void> multicastUDPClient() async {
    Timer.periodic(const Duration(seconds: 10),
            (timer) async {
              Logger.print('${DateTime.now()}:${timer.tick}:-----------------.');
              void onError(e){
                Logger.print('Error streamController.listen: $e');
              }
              const port = 8088;
              final udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
              final streamController = udpSocket.timeout(const Duration(seconds: 5), onTimeout: (sink) {
                Logger.print('${DateTime.now()}:Time Out Received.');
                sink.close();
              });
              udpSocket.broadcastEnabled = true;
              final streamSubscription =
                  streamController.listen((rawSocketEvent) async {
                    final dg = udpSocket.receive();
                    if (dg != null) {
                      // if (dg.address == InternetAddress(ipAddress))
                      {
                        Logger.print('${DateTime.now()}:Received:${dg.data.length}');
                        final str =
                        utf8.decode(dg.data).replaceAll('\n','').replaceAll('\r','');
                        final result = [
                          DateTime.now(),
                          dg.address,
                          dg.port.toString(),
                          str,
                        ];
                        Logger.print(result.toString());
                        final json = jsonDecode(str) as Map<String, dynamic>;
                        try {
                          final data = EnvironmentalConditions.fromJson(
                            json,
                            time: DateTime.now(),
                            host: '${dg.address.host}:${dg.port}',
                          );
                          Logger.print(data.toString());
                        } on EnvironmentalConditionsException catch(e){
                          Logger.print(e.errorMessageText);
                        }
                      }
                      udpSocket.close();
                    }
                  },
                  onDone: udpSocket.close,
                  onError: onError,
                  );

              // Wait for the socket to be done listening for a response
              await streamSubscription.asFuture<void>();
              await streamSubscription.cancel();
              udpSocket.close();
    });
  }
  multicastUDPClient();



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Weather Station'.hardcoded),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Weather Station'.hardcoded),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
