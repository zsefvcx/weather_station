import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger.dart';

class Settings  extends ChangeNotifier{
  ///Показывать логи
  static bool showLogData = true;

  ///широта
  static double lat = 51.368015;
  ///долгота
  static double lon = 42.075169;

  ///удаленный ip адрес для принудительного опроса
  static String remoteAddress = '192.168.100.12';
  static String remoteAddress2 = '192.168.2.149';
  ///Отловленные адрес из мультикаста
  static String? remoteAddressExt;

  /// Ошибка датчика или поправочный коэффициент x100
  static double deltaPressure = 967+63-89;
  static double deltaPressure2 = 967+63-89;
  static double deltaTemperature = 0;
  static double deltaTemperature2 = 0;
  static double deltahumidity = 0;
  static double deltahumidity2 = 0;

  ///Статус координат
  static bool gettingPosition = false;

  ///Размеры
  static const positionStartDefault = Offset(50, 20);
  static const sizeLite = Size(190, 110);
  ///Параметры OpenWeather
  ///город
  String sCity                      = 'Borisoglebsk,RU';
  /// api key
  String appid                      = 'a475299c0696cd14a80f54786915f293';

  int    listDataValueLength        = 1440;// Каждую минуту 1440 минут минимально 24 часа.

  String textSensorPosition01       = '1-----';
  String textSensorPosition02       = '2-----';
  ///удаленный ip адрес для принудительного опроса
  String ipAddress                  = '192.168.100.12';//'192.168.2.149';//'80.82.45.103';
  int    port                       = 8088;
  double opacityLite                = 0.7;
  double opacity                    = 1;
  bool   debug                      = true;
  bool   enableLog                  = true;//true;//false;
  bool   floatWin                   = false;
  bool   floatOnTop                 = false;
  Offset positionStart              = positionStartDefault;
  double calibrationPressure        = 10.3;
  double calibrationTemperature1    = 0;
  double calibrationTemperature2    = 0;
  bool   multicast                  = false;

  late Future<SharedPreferences> prefs;

  Future<void> readFromDisk() async {
    try{
      final prefs = await this.prefs;
      textSensorPosition01 = prefs.getString('textSensorPosition01')??'1-----';
      textSensorPosition02 = prefs.getString('textSensorPosition02')??'2-----';
      ipAddress = prefs.getString('ipAddress')??'192.168.100.12'; //'192.168.2.149';//'80.82.45.103';
      remoteAddress = ipAddress;
      port = prefs.getInt('port')??8088;
      opacityLite = prefs.getDouble('opacityLite')??0.7;
      opacity = prefs.getDouble('opacity')??1.0;
      debug = prefs.getBool('debug')??false;
      floatWin = prefs.getBool('floatWin')??true;
      enableLog = prefs.getBool('enableLog')??false; //true;//false;
      floatOnTop = prefs.getBool('floatOnTop')??true;
      positionStart = Offset(prefs.getDouble('dx')??50.0, prefs.getDouble('dy')??50.0);
      multicast = prefs.getBool('multicast')??false;
      sCity = prefs.getString('sCity')??'Borisoglebsk,RU';
      appid = prefs.getString('appid')??'a475299c0696cd14a80f54786915f293';
      calibrationPressure = prefs.getDouble('calibrationPressure')??10.3;
      calibrationTemperature1 = prefs.getDouble('calibrationTemperature1')??0.0;
      calibrationTemperature2 = prefs.getDouble('calibrationTemperature2')??0.0;
      listDataValueLength = prefs.getInt('listDataValueLength')??1440;
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
      await prefs.setString('textSensorPosition01',textSensorPosition01);
      await prefs.setString('textSensorPosition02',textSensorPosition02);
      await prefs.setString('ipAddress',ipAddress);
      await prefs.setInt('port',port);
      await prefs.setDouble('opacityLite',opacityLite);
      await prefs.setDouble('opacity',opacity);
      await prefs.setBool('debug',debug);
      await prefs.setBool('floatWin',floatWin);
      await prefs.setBool('enableLog',enableLog);
      await prefs.setBool('floatOnTop',floatOnTop);
      await prefs.setDouble('dx',positionStart.dx);
      await prefs.setDouble('dy',positionStart.dy);
      await prefs.setBool('multicast',multicast);
      await prefs.setString('sCity',sCity);
      await prefs.setString('appid',appid);
      await prefs.setDouble('calibrationPressure',calibrationPressure);
      await prefs.setDouble('calibrationTemperature1',calibrationTemperature1);
      await prefs.setDouble('calibrationTemperature2',calibrationTemperature2);
      await prefs.setInt('listDataValueLength', listDataValueLength);
      notifyListeners();
    } on Exception catch(e){
      Logger.print(e.toString(), error: true);
    }
  }

  void setDefault(){
    textSensorPosition01       = '1-----';
    textSensorPosition02       = '2-----';
    ipAddress                  = '192.168.100.12'; //'192.168.2.149';//'80.82.45.103';
    remoteAddress = ipAddress;
    port                       = 8088;
    opacityLite                = 0.7;
    opacity                    = 1.0;
    debug                      = false;
    floatWin                   = true;
    enableLog                  = false; //true;//false;
    floatOnTop                 = false;
    positionStart              = positionStartDefault;
    multicast                  = false;
    sCity                      = 'Borisoglebsk,RU';
    appid                      = 'a475299c0696cd14a80f54786915f293';
    calibrationPressure        = 10.3;
    calibrationTemperature1    = 0.0;
    calibrationTemperature2    = 0.0;
    listDataValueLength        = 1440;
    notifyListeners();
  }

}
