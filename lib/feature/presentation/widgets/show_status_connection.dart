import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_station/common/common.dart';
import 'package:weather_station/core/core.dart';

class ShowStatusConnection extends StatelessWidget {
  const ShowStatusConnection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final networkInfo = context.watch<NetworkInfo>();
    final remoteAddressExt = Settings.remoteAddressExt;
    return Row(
      children: [
        25.w,
        Icon(networkInfo.statusWD?Icons.wifi:Icons.signal_wifi_bad),
        25.w,
        Icon(networkInfo.statusEC?Icons.wifi:Icons.signal_wifi_bad),
        25.w,
        Icon(networkInfo.statusECB?Icons.wifi:Icons.signal_wifi_bad),
        25.w,
        if(networkInfo.statusECB && remoteAddressExt !=null)
          Text(remoteAddressExt),
      ],
    );
  }
}
