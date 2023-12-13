abstract class Settings {
  //Показывать логи
  static bool showLogData = true;
  //Ключ подключения
  static const String key = 'AAAAAB_KEY:16032023';
  //Число логов на основных
  static const int maxCountStack = 40000;
  //Адрес и настройки клиента
  static const String address = '127.0.0.1';
  static const int bindPort = 8088;
  static const int senderPort = 8088;
  static const Duration timeLimit = Duration(seconds: 5);
  static const Duration periodic = Duration(seconds: 10);
  //Параметры OpenWeather
  static String sCity                      = 'Borisoglebsk,RU';
  static String appid                      = 'a475299c0696cd14a80f54786915f293';
  static double lat = 51.368015;
  static double lon = 42.075169;


}
