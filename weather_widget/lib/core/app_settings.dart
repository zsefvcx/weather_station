import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_widget/core/core.dart';

import 'logger.dart';

class Settings  extends ChangeNotifier{
  ///Показывать логи
  static bool showLogData = true;
  ///удаленный ip адрес для принудительного опроса
  static String remoteAddress = '192.168.100.12';
  static String remoteAddress2 = '192.168.2.149';
  ///Отловленные адрес из мультикаста
  static String? remoteAddressExt;
  /// Ошибка датчика или поправочный коэффициент x100
  static double calibrationPressure2       = 0;
  static double calibrationTemperature2    = 0;


  ///удаленный ip адрес для принудительного опроса
  String ipAddress                  = '192.168.100.12';//'192.168.2.149';//'80.82.45.103';
  String remoteAddressM             = '';
  double opacity                    = 0.7;
  bool   multicast                  = false;
  ///Показывать логи
  bool   enableLog                  = true;//true;//false;
  bool   floatOnTop                 = false;
  Offset positionStart              = Constants.positionStartDefault;
  /// Ошибка датчика или поправочный коэффициент x100
  double calibrationPressure        = 0;
  double calibrationTemperature     = 0;


  late Future<SharedPreferences> prefs;

  Future<void> readFromDisk() async {
    try{
      final prefs = await this.prefs;
      ipAddress = prefs.getString('ipAddress')??'192.168.100.12'; //'192.168.2.149';//'80.82.45.103';
      remoteAddress = ipAddress;
      remoteAddressM = prefs.getString('remoteAddressM')??''; //'192.168.2.149';//'80.82.45.103';
      remoteAddressExt = remoteAddressM;
      opacity = prefs.getDouble('opacity')??0.7;
      enableLog = prefs.getBool('enableLog')??true; //true;//false;
      showLogData = enableLog;
      floatOnTop = prefs.getBool('floatOnTop')??true;
      positionStart = Offset(prefs.getDouble('dx')??50.0, prefs.getDouble('dy')??50.0);
      multicast = prefs.getBool('multicast')??false;
      calibrationPressure = prefs.getDouble('calibrationPressure')??0.0;
      calibrationPressure2 = calibrationPressure;
      calibrationTemperature = prefs.getDouble('calibrationTemperature')??0.0;
      calibrationTemperature2 = calibrationTemperature;
      notifyListeners();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
      setDefault();
      await safeToDisk();
    }
  }

  Future<void> safeToDisk() async {
    try{
      final prefs = await this.prefs;
      await prefs.setString('ipAddress',ipAddress);
      remoteAddress = ipAddress;
      await prefs.setString('remoteAddressM',remoteAddressExt??'');
      remoteAddressExt = remoteAddressM;
      await prefs.setDouble('opacity',opacity);
      await prefs.setBool('enableLog',enableLog);
      showLogData = enableLog;
      await prefs.setBool('floatOnTop',floatOnTop);
      await prefs.setDouble('dx',positionStart.dx);
      await prefs.setDouble('dy',positionStart.dy);
      await prefs.setBool('multicast',multicast);
      await prefs.setDouble('calibrationPressure',calibrationPressure);
      calibrationPressure2 = calibrationPressure;
      await prefs.setDouble('calibrationTemperature2',calibrationTemperature);
      calibrationTemperature2 = calibrationTemperature;
      notifyListeners();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
    }
  }

  void setDefault(){
    ipAddress                  = '192.168.100.12'; //'192.168.2.149';//'80.82.45.103';
    remoteAddress = ipAddress;
    remoteAddressM             = '';
    opacity                    = 0.7;
    enableLog                  = true; //true;//false;
    showLogData = enableLog;
    floatOnTop                 = false;
    positionStart              = Constants.positionStartDefault;
    multicast                  = false;
    calibrationPressure        = 0.0;
    calibrationPressure2 = calibrationPressure;
    calibrationTemperature     = 0.0;
    calibrationTemperature2 = calibrationTemperature;
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }

}
