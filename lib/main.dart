import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/core/core.dart';

Future<void> main() async {

  final stackDEC = StackDataEnvironmentalConditions();
  // final udpMultyCastReceiver = UDPClientSenderReceiver(stackDEC: stackDEC);
  // await udpMultyCastReceiver.run();

  final udpClient = UDPClientSenderReceiver(
    stackDEC: stackDEC,
    address: '192.168.100.12',
    bindPort: 0,
  );
  await udpClient.run(broadcastEnabled: false);

  //final timer = await udpClientSenderReceiver.run();
  //timer.cancel();

  runApp(MyApp(stackDEC: stackDEC,));
}


class MyApp extends StatelessWidget {
  final StackDataEnvironmentalConditions _stackDEC;
  
  const MyApp({
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
        home: MyHomePage(title: 'Weather Station'.hardcoded),
      ),
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
  @override
  Widget build(BuildContext context) {
    final stackDEC = context.watch<StackDataEnvironmentalConditions>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: stackDEC.length,
              //itemExtent: 100.0,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(1.0),
                  child: Material(
                    //elevation: 1.0,
                    //borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white, //green[index % 9 * 100],
                    child: Center(
                      child: Text(stackDEC.elementAt(index).toString()),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: 'Get',
        child: const Icon(Icons.get_app_outlined),
      ),
    );
  }
}
