abstract class Settings {
  //Показывать логи
  static bool showLogData = true;
  //Ключ подключения
  static const String key = 'AAAAAB_KEY:16032023';
  //Число логов на основных
  //Для метеостанции
  static const int maxCountStackEC = 40000;
  //Для погодного клиента
  static const int maxCountStackWD = 100;
  //Адрес и настройки клиента
  static const String address = '127.0.0.1';
  static const int bindPort = 8088;
  static const int senderPort = 8088;
  //Опрос метеостанции
  static const Duration timeLimitEC = Duration(seconds: 5);
  static const Duration periodicEC = Duration(seconds: 10);
  //Опрос для погодного клиента
  static const Duration timeLimitWD = Duration(seconds: 5);
  static const Duration periodicWD = Duration(minutes: 30);
  //Параметры OpenWeather
  static String sCity                      = 'Borisoglebsk,RU';
  static String appid                      = 'a475299c0696cd14a80f54786915f293';
  static double lat = 51.368015;
  static double lon = 42.075169;


}
