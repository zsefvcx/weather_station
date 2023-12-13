import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weather_station/core/core.dart';

class UDPClientSenderReceiverException implements Exception {
  final String errorMessageText;

  const UDPClientSenderReceiverException({
    required this.errorMessageText,
  });

  String errorMessage() {
    return 'Environmental Conditions Exception: $errorMessageText';
  }
}

class UDPClientSenderReceiver {
  //stack data
  final StackDataEnvironmentalConditions stackDEC;
  //Internr addres in text format: 'pool.ntp.org' or '127.0.0.1'
  final String address;
  //UDP bindPort = 0 as sender, = anyOther as resiver
  final int bindPort;
  //UDP senderPort = 8088 as sender, = anyOther as resiver
  final int senderPort;
  //timeLimit - limit await udp response
  final Duration timeLimit;
  //periodic - frequency of requests
  final Duration periodic;

  const UDPClientSenderReceiver({
    required this.stackDEC,
    this.address = '127.0.0.1',
    this.bindPort = 8088,
    this.senderPort = 8088,
    this.timeLimit = const Duration(seconds: 5),
    this.periodic = const Duration(seconds: 10),
  });

  Future<RawDatagramSocket> _bind() async {
    try {
      final serverAddress = (await InternetAddress.lookup(address)).first;
      final udpSocket = await RawDatagramSocket.bind(
          serverAddress.type == InternetAddressType.IPv6
              ? InternetAddress.anyIPv6
              : InternetAddress.anyIPv4, bindPort);
      return udpSocket;
    } on Exception catch(e, t){
      throw UDPClientSenderReceiverException(
          errorMessageText: 'Error bind Socket with:\n$e\n$t'
      );
    }
  }

  Stream<RawSocketEvent> _timeOut({required RawDatagramSocket udpSocket}){
    try{
      final streamController = udpSocket.timeout(const Duration(seconds: 5),
        onTimeout: (sink) {
          Logger.print('${DateTime.now()}:Time Out Received.');
          sink.close();
        },
      );
      return streamController;
    } on Exception catch(e, t){
      throw UDPClientSenderReceiverException(
          errorMessageText: 'Error timeOut Socket with:\n$e\n$t'
      );
    }
  }

  Future<int?> _send(String key, {
    required RawDatagramSocket udpSocket,
  }) async {
    try {
      final serverAddress = (await InternetAddress.lookup(address)).first;
      Logger.print('${DateTime.now()}:Send Data to server...');
      return udpSocket.send(
          utf8.encode(key), serverAddress, senderPort);
    } on Exception catch (e, t) {
      throw UDPClientSenderReceiverException(
          errorMessageText: 'Error send Socket with:\n$e\n$t'
      );
    }
  }


  StreamSubscription<RawSocketEvent> _listen({
    required Stream<RawSocketEvent> streamController,
    required RawDatagramSocket udpSocket
  }){
    void onError(e){
      Logger.print('Error streamController.listen: $e');
    }

    try{
      return streamController.listen((rawSocketEvent) async {
        final dg = udpSocket.receive();
        if (dg != null) {
          // if (dg.address == InternetAddress(ipAddress))
          {
            Logger.print('${DateTime.now()}:Received:${dg.data.length}');
            final str =
            utf8.decode(dg.data).replaceAll('\n','').replaceAll('\r','');
            final result = [
              DateTime.now(),
              dg.address,
              dg.port.toString(),
              str,
            ];
            Logger.print(result.toString());
            final json = jsonDecode(str) as Map<String, dynamic>;
            try {
              final data = EnvironmentalConditions.fromJson(
                json,
                time: DateTime.now(),
                host: '${dg.address.host}:${dg.port}',
              );
              Logger.print(data.toString(), safeToDisk: true);
              stackDEC.add(data);
            } on EnvironmentalConditionsException catch(e){
              Logger.print(e.errorMessageText);
            } on Exception catch(e, t){
              Logger.print(e.toString());
              Logger.print(t.toString());
            }
          }
          udpSocket.close();
        }
      },
        onDone: udpSocket.close,
        onError: onError,
      );
    } on Exception catch(e,t){
      throw UDPClientSenderReceiverException(
          errorMessageText: 'Error listen Socket with:\n$e\n$t'
      );
    }
  }

  Future<void> _startRcvUdp({
    bool broadcastEnabled = true,
    String key = Settings.key
  }) async {
    final udpSocket = await _bind();
    final streamController = _timeOut(udpSocket: udpSocket);
    udpSocket.broadcastEnabled = broadcastEnabled;
    final streamSubscription = _listen(
      streamController: streamController,
      udpSocket: udpSocket,
    );
    if(bindPort == 0) await _send(key, udpSocket: udpSocket);
    await streamSubscription.asFuture<void>();
    await streamSubscription.cancel();
    udpSocket.close();
  }


  Future<Timer> run({
    bool broadcastEnabled = true
  }) async {
    await _startRcvUdp(broadcastEnabled: broadcastEnabled);
    return Timer.periodic(periodic, (timer) async =>
        _startRcvUdp(broadcastEnabled: broadcastEnabled),
    );
  }
}
