import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weather_station/core/core.dart';

enum TypeDataRcv{
  multy,
  syngl,
  type2,
  type3;

  @override
  String toString(){
    switch (index){
      case 0:
        return 'multycast';
      case 1:
        return 'singlcast';
      case 2:
        return 'type2Broadcast';
      case 3:
        return 'type2Broadcast2';
      default:
        return name;
    }
  }
}

class UDPClientSenderReceiverException implements Exception {
  final String errorMessageText;

  const UDPClientSenderReceiverException({
    required this.errorMessageText,
  });

  String errorMessage() {
    return 'UDP Client Sender Receiver Exception: $errorMessageText';
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
  // Type aata receiver
  final TypeDataRcv type;
  // chaker network Status
  final NetworkInfo networkInfo;

  const UDPClientSenderReceiver({
    required this.stackDEC,
    required this.networkInfo,
    required this.type,
    this.address = Settings.address,
    this.bindPort = Settings.bindPort,
    this.senderPort = Settings.senderPort,
    this.timeLimit = Settings.timeLimitEC,
    this.periodic = Settings.periodicEC,
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
          errorMessageText: 'type:$type: Error bind Socket with:\n$e\n$t'
      );
    }
  }

  Stream<RawSocketEvent> _timeOut({required RawDatagramSocket udpSocket}){
    try{
      final streamController = udpSocket.timeout(timeLimit,
        onTimeout: (sink) {
          Logger.print('${DateTime.now()}:Time Out Received. type:$type');
          sink.close();
        },
      );
      return streamController;
    } on Exception catch(e, t){
      throw UDPClientSenderReceiverException(
          errorMessageText: 'type:$type: Error timeOut Socket with:\n$e\n$t'
      );
    }
  }

  Future<int?> _send(String key, {
    required RawDatagramSocket udpSocket,
  }) async {
    try {
      final serverAddress = (await InternetAddress.lookup(address)).first;
      Logger.print('${DateTime.now()}:Send Data to server. type:$type');
      return udpSocket.send(
          utf8.encode(key), serverAddress, senderPort);
    } on Exception catch (e, t) {
      throw UDPClientSenderReceiverException(
          errorMessageText: 'type:$type: Error send Socket with:\n$e\n$t'
      );
    }
  }


  StreamSubscription<RawSocketEvent> _listen({
    required Stream<RawSocketEvent> streamController,
    required RawDatagramSocket udpSocket
  }){
    void onError(e, t){
      throw UDPClientSenderReceiverException(
          errorMessageText: 'type:$type: Error streamController.listen with:\n$e\n$t'
      );
    }

    try{
      return streamController.listen((rawSocketEvent) async {
        final dg = udpSocket.receive();
        if (dg != null) {
          // if (dg.address == InternetAddress(ipAddress))
          {
            Logger.print('${DateTime.now()}:type:$type:Received:${dg.data.length}');
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
                type: type,
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
          errorMessageText: 'type:$type: Error listen Socket with:\n$e\n$t'
      );
    }
  }

  Future<void> _startRcvUdp({
    bool broadcastEnabled = true,
    String key = Settings.key
  }) async {
    try {
      final udpSocket = await _bind();
      final streamController = _timeOut(udpSocket: udpSocket);
      udpSocket.broadcastEnabled = broadcastEnabled;
      final streamSubscription = _listen(
        streamController: streamController,
        udpSocket: udpSocket,
      );
      if (bindPort == 0) await _send(key, udpSocket: udpSocket);
      await streamSubscription.asFuture<void>();
      await streamSubscription.cancel();
      udpSocket.close();
    } on Exception catch(e, t) {
      throw UDPClientSenderReceiverException(
          errorMessageText: 'type:$type: Error startRcvUdp Socket with:\n$e\n$t'
      );
    }
  }

  Future<Timer> run({
    bool broadcastEnabled = true
  }) async {
    try {
      await _startRcvUdp(broadcastEnabled: broadcastEnabled);
      return Timer.periodic(periodic, (timer) async =>
          _startRcvUdp(broadcastEnabled: broadcastEnabled),
      );
    } on Exception catch(e, t) {
      throw UDPClientSenderReceiverException(
          errorMessageText: 'type:$type: Error run Socket with:\n$e\n$t'
      );
    }
  }
}
