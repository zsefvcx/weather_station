abstract class Settings {
  static bool showLogData = true;
  static const String key = 'AAAAAB_KEY:16032023';
  static const int maxCountStack = 40000;
  static const String address = '127.0.0.1';
  static const int bindPort = 8088;
  static const int senderPort = 8088;
  static const Duration timeLimit = Duration(seconds: 5);
  static const Duration periodic = Duration(seconds: 10);
}
