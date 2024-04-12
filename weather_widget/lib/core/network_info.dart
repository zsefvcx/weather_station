import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_widget/core/core.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

class NetworkInfoImp implements NetworkInfo{
 final InternetConnectionChecker internetConnectionChecker;

 NetworkInfoImp({
   required this.internetConnectionChecker
 });

 @override
 Future<bool> get isConnected async {
   final remoteAddressExt = Settings.remoteAddressExt??'';
   final optionsList =
   List<AddressCheckOptions>.unmodifiable(<AddressCheckOptions>[
    if(remoteAddressExt.isNotEmpty)AddressCheckOptions(
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
   ]);
   internetConnectionChecker.addresses = optionsList;

   //Отладка. Удаленный адрес и отловленный мультикаст адрес
   Logger.print('${DateTime.now()}:remoteAddress:${Settings.remoteAddress}:remoteAddressExt:${remoteAddressExt==''?'-':remoteAddressExt}');


   return internetConnectionChecker.hasConnection;
 }

}
