import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/domain/domain.dart';
import 'package:weather_widget/modules/environment/presentation/bloc/environment_bloc/environment_bloc.dart';
import 'package:window_manager/window_manager.dart';

const black = Color(0xFF000000);
const white = Color(0xFFF0F0F0);
const red = Color(0xFFC50F0E);

final borderRadius = Platform.isWindows?20.0:0.0;
const mainFont = 'SF UI Display';
const align = TextAlign.start;
const style = TextStyle(
  fontFamily: mainFont,
  color: black,
  fontSize: 15,
  fontWeight: FontWeight.w700,
  letterSpacing: 0,
  height: 15/17,
);
const styleLite = TextStyle(
  fontFamily: mainFont,
  color: red,
  fontSize: 10,
  fontWeight: FontWeight.normal,
  letterSpacing: 0,
  height: 10/14,
);

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
    BlocProvider.of<EnvironmentBloc>(context).add(const EnvironmentEvent.receiveData());
    final settingsApp = context.watch<Settings>();
    _settingsApp = settingsApp;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _CustomAppBarWin(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
              ),
              const _EnvironmentWidget(),
            ],
          ),
        ),
        floatingActionButton: const _CustomFloatingIconStatus(),
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

    final pos = await windowManager.getPosition();
    final settingsApp = _settingsApp;
    if(settingsApp !=null)settingsApp.positionStart = pos + position - _positionStart;
    await windowManager.setPosition(pos + position - _positionStart);
    if (
    (pos.dx + position.dx - _positionStart.dx).toInt().abs() > 20  ||
        (pos.dy + position.dy - _positionStart.dy).toInt().abs() > 20
    ){
      //await settingsApp.safeToDisk();
    }

  }
}

class _CustomFloatingIconStatus extends StatelessWidget {
  const _CustomFloatingIconStatus();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentBloc, EnvironmentState>(
      builder: (_, state) {
        return state.map(
          loading: (value) => const Icon(Icons.connect_without_contact,
            size: 14,
            color: black,
            opticalSize: 14,),
          stop: (value) => const Icon(Icons.close,
            size: 14,
            color: black,
            opticalSize: 14,),
          loaded: (value) => Icon(
            value.type != TypeData.external
              ?Icons.leak_add_outlined
              :Icons.leak_remove,
            size: 14,
            color: black,
            opticalSize: 14,),
          error: (value) => const Icon(Icons.error_outline_outlined,
            size: 14,
            color: black,
            opticalSize: 14,),
        );
      },
    );
  }
}

class _CustomAppBarWin extends StatelessWidget {
  const _CustomAppBarWin({
    required this.onPanStart,
    required this.onPanUpdate,
  });

  final void Function(BuildContext context, DragStartDetails details) onPanStart;
  final void Function(BuildContext context, DragUpdateDetails details) onPanUpdate;

  @override
  Widget build(BuildContext context) {
    final settingsApp = context.watch<Settings>();
    final block = BlocProvider.of<EnvironmentBloc>(context);
    final valueNotifierPinAction = ValueNotifier<bool>(settingsApp.floatOnTop);

    return GestureDetector(
      onPanStart: (details) => onPanStart(context, details),
      onPanUpdate: (details) => onPanUpdate(context, details),
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: Container(
          color: black,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () async {
                valueNotifierPinAction.value = !valueNotifierPinAction.value;
                settingsApp.floatOnTop = valueNotifierPinAction.value;
                await windowManager.setAlwaysOnTop(settingsApp.floatOnTop);
              },
                icon: ValueListenableBuilder<bool>(
                    valueListenable: valueNotifierPinAction,
                    builder: (_, value, __) {
                      return Icon(
                        !value?Icons.check_box_outline_blank
                            :Icons.library_add_check_outlined,
                        size: 7,
                        color: white,
                        opticalSize: 7,
                      );
                    }
                ),
                tooltip: 'Pin'.hardcoded,
              ),
              IconButton(onPressed: () async {
                block.add(const EnvironmentEvent.stopGet());
                await Future.delayed(const Duration(seconds: 1));
                block..add(const EnvironmentEvent.startGet())
                  ..add(const EnvironmentEvent.receiveData());
              },
                icon: const Icon(Icons.restart_alt,
                  size: 7,
                  color: white,
                  opticalSize: 7,
                ),
                tooltip: 'Restart'.hardcoded,
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
                await settingsApp.safeToDisk();
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
    );
  }
}

class _EnvironmentWidget extends StatelessWidget {
  const _EnvironmentWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentBloc, EnvironmentState>(
      builder: (_, state) {
        return state.map(
            loading: (value) {
              return const Padding(
                padding: EdgeInsets.all(15),
                child: Center(child: CircularProgressIndicator()),
              );
            },
            loaded: (value) {
              final data = value.data;
              return _ShowStatusEnvironmentWidget(data: data);
            },
            error: (value) {
              final data = value.cacheData;
              return Column(
                children: [
                  if(data!=null)_ShowStatusEnvironmentWidget(data: data),
                  Center(
                      child: Text(value.massage, style: styleLite, textAlign: align)
                  ),
                ],
              );
            },
            stop: (value) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                    child: Text('Poll stopped'.hardcoded,  style: styleLite, textAlign: align)
                ),
              );
            },
        );
      },
    );
  }
}

class _ShowStatusEnvironmentWidget extends StatelessWidget {
  const _ShowStatusEnvironmentWidget({
    super.key,
    required this.data,
  });

  final EnvironmentDataEntity data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
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
                      Text('${data.tempInt} °C', style: style, textAlign: align,),
                      5.h,
                      Text('${data.humidityInt} %', style: style, textAlign: align,),
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
                      Text('${data.tempExt} °C', style: style, textAlign: align,),
                      5.h,
                      Text('${data.humidityExt} %', style: style, textAlign: align,),
                    ],
                  ),
                ),
              ],
            ),
            5.h,
            Text('${data.pressure} mmHg', style: style, textAlign: align,),
          ],
        ),
      ),

    );
  }
}
