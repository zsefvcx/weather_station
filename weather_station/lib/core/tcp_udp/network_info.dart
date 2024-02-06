import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_station/common/common.dart';

abstract class NetworkInfo extends ChangeNotifier{
  bool statusWD = false;
  bool statusEC = false;
  bool statusECB = false;

  Future<bool> get isConnectedWD;
  Future<bool> get isConnectedECB;
  Future<bool> get isConnectedEC;

}

class NetworkInfoImp extends NetworkInfo{
  final InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImp({
    required this.internetConnectionChecker
  });

  @override
  Future<bool> get isConnectedEC async {
    final remoteAddressExt = Settings.remoteAddressExt;
    final optionsList =
      List<AddressCheckOptions>.unmodifiable(<AddressCheckOptions>[
        if(remoteAddressExt != null)AddressCheckOptions(
          address: InternetAddress(
            remoteAddressExt,
            type: InternetAddressType.IPv4,
          ),
          port: Constants.tcpPort,
        ),
        AddressCheckOptions(
          address: InternetAddress(
            Settings.remoteAddress,
            type: InternetAddressType.IPv4,
          ),
          port: Constants.tcpPort,
        ),
        AddressCheckOptions(
          address: InternetAddress(
            Settings.remoteAddress2,
            type: InternetAddressType.IPv4,
          ),
          port: Constants.tcpPort,
        ),
      ]);
    internetConnectionChecker.addresses = optionsList;

    statusEC = await internetConnectionChecker.hasConnection;
    notifyListeners();
    return statusEC;
  }

  @override
  Future<bool> get isConnectedWD async {
    final optionsList =
    List<AddressCheckOptions>.unmodifiable(<AddressCheckOptions>[
      ...InternetConnectionChecker.DEFAULT_ADDRESSES,
    ]);
    internetConnectionChecker.addresses = optionsList;
    statusWD = await internetConnectionChecker.hasConnection;
    notifyListeners();
    return statusWD;
  }

  @override
  Future<bool> get isConnectedECB async {
    final remoteAddressExt = Settings.remoteAddressExt;
    if(remoteAddressExt == null) {
      statusECB = false;
      notifyListeners();
      return statusECB;
    }

    final optionsList =
    List<AddressCheckOptions>.unmodifiable(<AddressCheckOptions>[
      AddressCheckOptions(
        address: InternetAddress(
          remoteAddressExt,
          type: InternetAddressType.IPv4,
        ),
        port: Constants.tcpPort,
      ),
    ]);
    internetConnectionChecker.addresses = optionsList;

    statusECB = await internetConnectionChecker.hasConnection;
    notifyListeners();
    return statusECB;
  }

}
