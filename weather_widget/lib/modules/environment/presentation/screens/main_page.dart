import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/bloc/environment_bloc/environment_bloc.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var _positionStart = Offset.zero;
  Settings? _settingsApp;

  @override
  Widget build(BuildContext context) {
    final block = BlocProvider.of<EnvironmentBloc>(context)
        ..add(const EnvironmentEvent.receiveData());
    _settingsApp = context.watch<Settings>();

    const mainFont = 'SF UI Display';
    const black = Color(0xFF000000);
    const white = Color(0xFFF0F0F0);
    const align = TextAlign.start;
    const borderRadius = 20.0;
    const style = TextStyle(
      fontFamily: mainFont,
      color: black,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 15/17,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onPanStart: (details) => _onPanStart(context, details),
                onPanUpdate: (details) => _onPanUpdate(context, details),
                child: MouseRegion(
                  cursor: SystemMouseCursors.move,
                  child: Container(
                    color: black,
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: () {
                          block
                            ..add(const EnvironmentEvent.startGet())
                            ..add(const EnvironmentEvent.receiveData());
                        },
                          icon: const Icon(Icons.play_arrow_outlined,
                            size: 7,
                            color: white,
                            opticalSize: 7,
                          ),
                          tooltip: 'Start'.hardcoded,
                        ),
                        IconButton(onPressed: () {
                            block.add(const EnvironmentEvent.stopGet());
                          },
                          icon: const Icon(Icons.stop_circle_outlined,
                            size: 7,
                            color: white,
                            opticalSize: 7,
                          ),
                          tooltip: 'Stop'.hardcoded,
                        ),
                        IconButton(onPressed: () async {
                          await windowManager.minimize();
                        },
                          icon: const Icon(Icons.minimize,
                            size: 7,
                            color: white,
                            opticalSize: 7,
                          ),
                          tooltip: 'Minimize'.hardcoded,
                        ),
                        IconButton(onPressed: () async {
                            await _settingsApp?.safeToDisk();
                            await windowManager.close();
                          },
                          icon: const Icon(Icons.close,
                            size: 7,
                            color: white,
                            opticalSize: 7,
                          ),
                          tooltip: 'Close'.hardcoded,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: BlocBuilder<EnvironmentBloc, EnvironmentState>(
                  builder: (_, state) {
                    return state.map(
                        loading: (value) {
                          return const Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(),
                          );
                        },
                        loaded: (value) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Int', style: style, textAlign: align,),
                                          5.h,
                                          Text('${value.data.tempInt} °C', style: style, textAlign: align,),
                                          5.h,
                                          Text('${value.data.humidityInt} %', style: style, textAlign: align,),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Ext', style: style, textAlign: align,),
                                          5.h,
                                          Text('${value.data.tempExt} °C', style: style, textAlign: align,),
                                          5.h,
                                          Text('${value.data.humidityExt} %', style: style, textAlign: align,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                5.h,
                                Text('${value.data.pressure} mmHg', style: style, textAlign: align,),
                              ],
                            ),

                          );
                        },
                        error: (value) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(value.massage, style: style, textAlign: align),
                          );
                        },
                        stop: (value) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text('Poll stopped'.hardcoded,  style: style, textAlign: align),
                          );
                        },
                    );



                    // return Container(
                    //   width: 100,
                    //   height: 200,
                    //   color: Colors.black,
                    //   child: const Text('T1 C, H1 %, P mmHd'),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<EnvironmentBloc, EnvironmentState>(
          builder: (_, state) {
            return state.map(
              loading: (value) => const Icon(Icons.connect_without_contact,
                size: 14,
                color: black,
                opticalSize: 14,),
              stop: (value) => const Icon(Icons.leak_remove,
                size: 14,
                color: black,
                opticalSize: 14,),
              loaded: (value) => const Icon(Icons.leak_add_outlined,
                size: 14,
                color: black,
                opticalSize: 14,),
              error: (value) => const Icon(Icons.error_outline_outlined,
                size: 14,
                color: black,
                opticalSize: 14,),
            );
          },
        ),
      ),
    );

  }

  void _onPanStart(BuildContext context, DragStartDetails details) {
    _positionStart = details.globalPosition;
  }

  Future<void> _onPanUpdate(
      BuildContext context, DragUpdateDetails details) async {
    final position = Offset(
        details.globalPosition.dx /*MediaQuery.of(context).devicePixelRatio*/,
        details.globalPosition.dy /*MediaQuery.of(context).devicePixelRatio*/
    );

    //print(MediaQuery.of(context).size);

    // if (position.dy >= appBarHeight && appBarHeight > 0) {
    //   return;
    // }
    Offset pos = await windowManager.getPosition();
    final settingsApp = _settingsApp;
    if(settingsApp !=null)settingsApp.positionStart = pos + position - _positionStart;
    await windowManager.setPosition(pos + position - _positionStart);
    if (
    ((pos.dx + position.dx - _positionStart.dx).toInt()).abs() > 20  ||
        ((pos.dy + position.dy - _positionStart.dy).toInt()).abs() > 20
    ){
      //await settingsApp.safeToDisk();
    }

  }
}
