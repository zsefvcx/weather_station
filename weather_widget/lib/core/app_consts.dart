
import 'dart:io';

import 'package:flutter/material.dart';

abstract final class Constants {
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

  ///Контроллер должен посылать информацию каждые 10 минут.
  ///Если сообщение не пришло в течении 30 минут ,то что то пошло не так
  ///Но он спит и надо бы время увеличит до часу
  static const timeOutShowError = 60*60;

  ///Сохраняем данные в кеш каждые два часа
  static const timeOutSafeDataToCache = 2*60*60;

  ///NullUID
  static const nullUuid = '00000000-0000-0000-0000-000000000000';

  ///Округленность основного окна
  static final borderRadius = Platform.isWindows ? 20.0 : 0.0;

  ///Наимненование
  static const title = 'Weather Station';

  ///Размеры
  static const positionStartDefault = Offset(50, 20);
  static const sizeLite = Size(160, 105);
  static const sizeLiteDouble = Size(200, 123);

   /// Сообщения от ошибках
  static const serverFailureMessage = 'Server Failure';
  static const cacheFailureMessage = 'Cache Failure';
  static const cacheFailureMessageRead = 'Cache Failure Read';
  static const cacheFailureMessageWrite = 'Cache Failure Write';
  static const timeOutFailureMessage = 'Time Out Failure';
  static const unexpectedErrorMessage = 'Unexpected Error';

  ///Время сна устройства
  static const timeSleepDevices = 10*60;
}
