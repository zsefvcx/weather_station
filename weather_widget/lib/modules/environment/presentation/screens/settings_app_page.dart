import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/modules/environment/presentation/presentation.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class SettingsAppPage extends StatefulWidget {
  const SettingsAppPage({super.key});

  @override
  State<SettingsAppPage> createState() => _SettingsAppPageState();
}

class _SettingsAppPageState extends State<SettingsAppPage> {
  @override
  Widget build(BuildContext context) {
    final settingsApp = context.watch<Settings>();
    final settingsAppAction = SettingsAppAction(context: context);
    const heightContainer = 60.0;
    final widgetList = <Widget>[
      CustomMainBarWin(
        title: Constants.title,
        action: () async => context.router.back(),
        iconAction: Icons.arrow_back,
        textAction: 'Back'.hrd,
      ),
      ///opacity
      CustomSliderWidget(
        icon: Icons.opacity,
        text: 'Opacity:'.hrd,
        value: settingsApp.opacity,
        onChanged: settingsAppAction.opacityChanged,
      ),
      ///ipAddress
      Card(
        color: Colors.grey,
        margin: const EdgeInsets.all(5),
        elevation: 10,
        child: Container(
          height: heightContainer,
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            //focusNode: _focusNodes[7],
            enabled: true,
            style: AppFonts.style,
            keyboardType: TextInputType.text,
            //textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              icon: CustomIcon(Icons.device_thermostat_outlined),
              hintText: 'IP address',
              labelText: 'IP Address:',
              labelStyle: AppFonts.style,
              border: InputBorder.none,
            ),
            //style: widget._textStyle,
            maxLines: 1, minLines: 1, maxLength: 15, //
            initialValue: settingsApp.ipAddress,
            inputFormatters: const[
              // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
              // LengthLimitingTextInputFormatter(15),
              // IpAddInFormat(),
            ],
            onEditingComplete: () {
              // if (settingsApp.ipAddress.isEmpty) {
              //   _focusNodes[7].requestFocus();
              // } else {
              //   _focusNodes[8].requestFocus();
              // }
            },
            onChanged: (text) async {
              setState(() {
                settingsApp.ipAddress = text;
              });
              await settingsApp.safeToDisk();
              settingsApp.notify();
              // if (widget._vDebugMode) {
              //   print(
              //       'Submitted `settingsApp`${settingsApp.ipAddress}');
              // }
            },
            validator: (value) {
              return value!.contains('@')
                  ? 'Do not use the @ char.'
                  : null;
            },
          ),
        ),
      ),
      ///multicast
      ///enableLog
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: AppColors.blue,
                child: ListView.builder(
                  itemCount: widgetList.length,
                  itemBuilder: (_, index) => widgetList[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
