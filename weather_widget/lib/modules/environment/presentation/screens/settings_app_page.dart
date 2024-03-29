import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';

import '../presentation.dart';

@RoutePage()
class SettingsAppPage extends StatefulWidget {
  const SettingsAppPage({super.key});

  @override
  State<SettingsAppPage> createState() => _SettingsAppPageState();
}

class _SettingsAppPageState extends State<SettingsAppPage> {
  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomMainBarWin(
                        title: Constants.title,
                        action: ()async=>context.router.back(),
                        iconAction: Icons.arrow_back,
                        textAction: 'Back'.hrd,
                      ),
                      Container(
                        color: AppColors.green,
                      )
                      ///opacity
                      ///ipAddress
                      ///multicast
                      ///enableLog
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
