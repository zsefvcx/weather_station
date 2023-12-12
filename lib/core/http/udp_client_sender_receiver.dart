
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weather_station/core/core.dart';

class UDPClientSenderReceiver {
  String ipAddress = '127.0.0.1';
  int port = 8088;
  int timeOutUDP = 5;

  int listDataValueLength = 1440;
  double calibrationPressure = 10.3;
  double calibrationTemperature1    = 0;
  double calibrationTemperature2    = 0;

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
                if (json['key'] != Settings.key) {
                  throw FormatException(
                      '${DateTime.now()}: Expected ID code is not received or wrong!');
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
    }
  }

  void dispose() {
    _streamSubscription.cancel();
    _udpSocket.close();
  }
}
