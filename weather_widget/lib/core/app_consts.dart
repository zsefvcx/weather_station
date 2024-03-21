
const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';
const timeOutFailureMessage = 'Time Out Failure';
const unexpectedErrorMessage = 'Unexpected Error';

abstract class Constants {
  ///Ключ подключения
  static const String key = 'AAAAAB_KEY:16032023';

  ///Число логов на основных
  ///Дефолтное значение для всех
  /// //24x60x60 - записывать cтолько раз это по дефолту
  static const int maxCountStack = 24*60*60;
  ///Для метеостанции
  static const int maxCountStackEC = maxCountStack~/periodicECSec;
  ///Для погодного клиента
  static const int maxCountStackWD = maxCountStack~/periodicWDSec;
  ///Адрес и настройки клиента
  ///данные для получения широковещательных оповещений
  static const String address = '127.0.0.1';
  static const int bindPort = 8088;
  ///порт принудительного опроса
  static const int senderPort = 8088;
  ///tcp port
  static const int tcpPort = 80;

  ///Опрос метеостанции
  ///лимит опроса
  static const int timeLimitECSec = 15;
  static const Duration timeLimitEC = Duration(seconds: timeLimitECSec);

  ///периодичность
  static const int periodicECSec = 5;
  static const Duration periodicEC = Duration(seconds: periodicECSec);

  ///Опрос для погодного клиента
  ///лимит опроса
  static const int timeLimitWDSec = 15;
  static const Duration timeLimitWD = Duration(seconds: timeLimitWDSec);

  ///периодичность
  static const int periodicWDSec = 15;
  static const Duration periodicWD = Duration(minutes: periodicWDSec);

  ///Часы
  ///периодичность
  static const int periodicDTSec = 60;
  static const Duration periodicDT = Duration(seconds: periodicDTSec);

  ///Периодичность дефолтная
  static const int periodicSec = 30;
  static const Duration periodic = Duration(seconds: periodicSec);


  ///Константа для перевода давления в мм рт.ст.
  static const toMmHg = 0.00750063755419211;

}
