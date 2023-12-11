
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weather_station/core/core.dart';

class UDPClientSenderReceiver {
  String ipAddress = '127.0.0.1';
  int port = 8088;
  int timeOutUDP = 5;
  TypeDataReceiver type = TypeDataReceiver.type0;
  int listDataValueLength = 1440;
  double calibrationPressure = 10.3;
  double calibrationTemperature1    = 0;
  double calibrationTemperature2    = 0;

  late EnvConditions evnState;
  late List<DataValue> listDataValue;

  bool vDebugMode = false;
  bool broadcast = false;

  UDPClientSenderReceiver();

  //нужно для повтора приема мультикаст сообщений...
  bool repeatMulticastReceiver = false;

  late RawDatagramSocket _udpSocket;
  late Stream<RawSocketEvent> _streamController;
  late StreamSubscription<dynamic> _streamSubscription;

  Future<void> _bind({int port = 0}) async {
    try {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    } on Exception catch(e) {
      Logger.print('err bind function: $e', name: 'err', error: true, );
      //ignore: avoid_catches_without_on_clauses
    } catch(ee, t){
      Logger.print('$ee\n$t', name: 'err', error: true);
    }
  }

  Future<void> _broadcastEnabled(bool value) async {
    _udpSocket.broadcastEnabled = value;
  }

  void _setTimeOut() {
    try {
      _streamController =
          _udpSocket.timeout(Duration(seconds: timeOutUDP), onTimeout: (sink) {
            Logger.print('${DateTime.now()}:Time Out Received.');
            final result = [
              DateTime.now(),
              ipAddress,
              port.toString(),
              'Time Out Received.',
            ];
            Logger.print(result.toString());

            if (type == TypeDataReceiver.type1) {
              //single
              evnState.errorStatSingle++;
              if (evnState.errorStatSingle > 3) evnState.errorStatSingle = 3;
            } else if (type == TypeDataReceiver.type2) {
              //multicast
              evnState.errorStateBroadCast++;
              if (evnState.errorStateBroadCast > 3) {
                evnState.errorStateBroadCast = 3;
              }
            } else {
              // ничего не делаем
            }
            if (evnState.errorStatSingle >= 3 ||
                evnState.errorStateBroadCast >= 3) {
              evnState.type = TypeDataReceiver.type0; // потеря связи
            }
            sink.close();
            repeatMulticastReceiver = false;
          });
    } on Exception catch (e) {
      Logger.print('err setTimeOut function: $e');
    }
  }

  void _listenRawSocketEvent() {
    try {
      _streamSubscription =
          _streamController.listen((rawSocketEvent) async {
            final dg = _udpSocket.receive();
            if (dg != null) {
              if (dg.address == InternetAddress(ipAddress))
              {
                Logger.print('${DateTime.now()}:Received:');
                final str =
                utf8.decode(dg.data).replaceAll('\n', '').replaceAll('\r', '');
                final result = [
                  DateTime.now(),
                  ipAddress,
                  port.toString(),
                  str,
                ];
                Logger.print(result.toString());
                final json = jsonDecode(str) as Map<String, dynamic>;
                if (json['ID'] != EnvConditions.id) {
                  throw FormatException(
                      '${DateTime.now()}: Expected ID code is not received or wrong!');
                }

                evnState.fromJson(json, ipAddress, DateTime.now());
                if (type == TypeDataReceiver.type1) {
                  //single
                  evnState.errorStatSingle--;
                  if (evnState.errorStatSingle <= 0) {
                    evnState..errorStatSingle = 0
                            ..type = TypeDataReceiver.type1;
                  }
                } else if (type == TypeDataReceiver.type2) {
                  //multicast
                  evnState.errorStateBroadCast--;
                  if (evnState.errorStateBroadCast <= 0) {
                    evnState..errorStateBroadCast = 0
                            ..type = TypeDataReceiver.type2;
                  }
                } else {
                  // ничего не делаем
                }
                if(evnState.press!=null) {
                  evnState.press = evnState.press! + calibrationPressure;
                }
                if(evnState.temp1!=null) {
                  evnState.temp1 = evnState.temp1! + calibrationTemperature1;
                }
                if(evnState.temp2!=null) {
                  evnState.temp2 = evnState.temp2! + calibrationTemperature2;
                }
                Logger.print('$evnState\n');
                listDataValue.add(DataValue(
                  time: evnState.time,
                  t1: evnState.temp1,
                  h1: evnState.temp2,
                  t2: evnState.humid1,
                  h2: evnState.humid2,
                  t3: evnState.temp3,
                  h3: evnState.humid3,
                  p3: evnState.press3,
                  p1: evnState.press,
                ));
                if (listDataValue.length > listDataValueLength) {
                  listDataValue.removeAt(0);
                }

                evnState.notify();

                if (listDataValue.length%10==0){//сохраняем каждые 10 сообщений
                  await evnState.safeToDisk();
                }

              }
              _udpSocket.close();
              repeatMulticastReceiver = false;
            }
          });
    } on Exception catch (e) {
      Logger.print('err setTimeOut function: $e');
      _udpSocket.close();
      repeatMulticastReceiver = false;
    }
  }

  Future<int?> _send(String data) async {
    try {
      Logger.print('${DateTime.now()}:Send Data to server...');
      final result = [
        DateTime.now(),
        ipAddress,
        port.toString(),
        'Send Data to server...',
      ];
      Logger.print(result.toString());
      return _udpSocket.send(
          utf8.encode(data), InternetAddress(ipAddress), port);
    } on Exception catch (e) {
      Logger.print('err send function: $e');
    }
    return null;
  }

  Future<void> sendAndReceiveDate({required String data}) async {
    try {
      await _bind();
      _setTimeOut();
      await _broadcastEnabled(broadcast);
      _listenRawSocketEvent();
      await _send(data);
      await _streamSubscription.asFuture<void>();
    } on Exception catch (e) {
      Logger.print('err localReceiveDate function: $e');
      evnState.errorStatSingle++;
      if (evnState.errorStatSingle >= 3) {
        evnState.type = TypeDataReceiver.type0;
      }
    }
  }

  Future<void> multicastReceiverDate() async {
    try {
      await _bind(port: port);
      _setTimeOut();
      await _broadcastEnabled(broadcast);
      _listenRawSocketEvent();
      await _streamSubscription.asFuture<void>();
    } on Exception catch (e) {
      Logger.print('err multicastReceiverDate function: $e');
      evnState.errorStateBroadCast++;
      if (evnState.errorStateBroadCast >= 5) {
        evnState.type = TypeDataReceiver.type0; // потеря связи
      }
    }
  }

  void dispose() {
    _streamSubscription.cancel();
    _udpSocket.close();
  }
}
