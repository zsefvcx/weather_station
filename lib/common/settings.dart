abstract class Settings {
  ///Показывать логи
  static bool showLogData = true;

  ///Ключ подключения
  static const String key = 'AAAAAB_KEY:16032023';

  ///Число логов на основных
  ///Для метеостанции
  static const int maxCountStackEC = 40000;

  ///Для погодного клиента
  static const int maxCountStackWD = 100;

  ///Адрес и настройки клиента
  ///данные для получения широковещательных оповещений
  static const String address = '127.0.0.1';
  static const int bindPort = 8088;

  ///удаленный ip адресс для принудительного опроса
  static const String remoutAddress = '192.168.100.12';

  ///порт принудительного опроса
  static const int senderPort = 8088;

  ///Опрос метеостанции
  ///лимит опроса
  static const Duration timeLimitEC = Duration(seconds: 5);

  ///переодичность
  static const Duration periodicEC = Duration(seconds: 10);

  ///Опрос для погодного клиента
  ///лимит опроса
  static const Duration timeLimitWD = Duration(seconds: 5);

  ///переодичность
  static const Duration periodicWD = Duration(minutes: 30);

  ///Часы
  ///переодичность
  static const Duration periodic = Duration(seconds: 60);

  ///Параметры OpenWeather
  ///город
  static String sCity = 'Borisoglebsk,RU';

  /// api key
  static String appid = 'a475299c0696cd14a80f54786915f293';

  ///широта
  static double lat = 51.368015;

  ///долгота
  static double lon = 42.075169;
}
