import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';
import 'package:weather_station/feature/presentation/widgets/widgets.dart';

class ShowStatusConnection extends StatefulWidget {
  const ShowStatusConnection({
    super.key,
  });

  @override
  State<ShowStatusConnection> createState() => _ShowStatusConnectionState();
}

class _ShowStatusConnectionState extends State<ShowStatusConnection> {

  @override
  Widget build(BuildContext context) {
    final networkInfo = context.watch<NetworkInfo>();
    final remoteAddressExt = Settings.remoteAddressExt;
    return Row(
      children: [
        50.w,
        ShowWidgetWithPrompt(
          child: Icon(networkInfo.statusWD?Icons.wifi:Icons.signal_wifi_bad),
            prompt: 'Internet Statatus',
        ),
        25.w,
        ShowWidgetWithPrompt(
          child: Icon(networkInfo.statusEC?Icons.wifi:Icons.signal_wifi_bad),
          prompt: 'Devices Status',
        ),
        25.w,
        ShowWidgetWithPrompt(
          child: Icon(networkInfo.statusECB?Icons.wifi:Icons.signal_wifi_bad),
          prompt: 'Broadcast Devices Status',
        ),
        25.w,
        if(networkInfo.statusECB && remoteAddressExt !=null)
          ShowWidgetWithPrompt(
            child: Text(remoteAddressExt),
            prompt: 'Broadcast Devices IP',
          ),
      ],
    );
  }
}
