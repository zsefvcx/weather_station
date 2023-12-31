
abstract class Settings {
  ///Показывать логи
  static bool showLogData = true;

  ///Параметры OpenWeather
  ///город
  static String sCity = 'Borisoglebsk,RU';

  /// api key
  static String appid = 'a475299c0696cd14a80f54786915f293';

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
}
