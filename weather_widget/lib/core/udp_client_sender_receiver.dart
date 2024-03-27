import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weather_widget/core/core.dart';

enum TypeDataRcv{
  multi,
  single,
  type2,
  type3;

  @override
  String toString(){
    switch (index){
      case 0:
        return 'multicast';
      case 1:
        return 'singlecast';
      case 2:
        return 'type2Broadcast';
      case 3:
        return 'type2Broadcast2';
      default:
        return name;
    }
  }
}

class UDPClientSenderReceiver {
  //Internal address in text format: 'pool.ntp.org' or '127.0.0.1'
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
  // StreamController
  final EnvironmentStreamService serviceEC;
  //Timer
  static Timer? _timer;

  const UDPClientSenderReceiver({
    required this.serviceEC,
    required this.type,
    required this.networkInfo,
    this.address = Constants.address,
    this.bindPort = Constants.bindPort,
    this.senderPort = Constants.senderPort,
    this.timeLimit = Constants.timeLimitEC,
    this.periodic = Constants.periodicEC,
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
               Logger.print('type:$type: Error bind Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error bind Socket'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error bind Socket with:\n$e\n$t'
      );
    }
  }

  Stream<RawSocketEvent> _timeOut({required RawDatagramSocket udpSocket}){
    try{
      final streamController = udpSocket.timeout(timeLimit,
        onTimeout: (sink) {
          Logger.print('${DateTime.now()}:Time Out Received. type:$type');
          serviceEC.add((const ServerFailure(errorMessage: 'Time Out Received'), null));
          sink.close();
        },
      );
      return streamController;
    } on Exception catch(e, t){
               Logger.print('type:$type: Error timeOut Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error timeOut Socket'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error timeOut Socket with:\n$e\n$t'
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
               Logger.print('type:$type: Error send Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error send Socket'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error send Socket with:\n$e\n$t'
      );
    }
  }


  StreamSubscription<RawSocketEvent> _listen({
    required Stream<RawSocketEvent> streamController,
    required RawDatagramSocket udpSocket
  }){
    void onError(e, t){
               Logger.print('type:$type: Error streamController.listen with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error streamController'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error streamController.listen with:\n$e\n$t'
      );
    }

    try{
      return streamController.listen((rawSocketEvent) async {
        final dg = udpSocket.receive();
        if (dg != null) {
          //final remoteAddressExt = Settings.remoteAddressExt;
          //if (remoteAddressExt == null || dg.address.address == remoteAddressExt)
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
            final key = json['key'] as String?;
            if(key != null && key != Constants.key) {
              serviceEC.add((const ServerFailure(errorMessage: 'Error key message'), null));
              throw UDPClientSenderReceiverException(
                errorMessage: 'type:$type: Error key message key:$key'
              );
            }
            try {
              final dataEC = EnvironmentalConditions.fromJson(
                json,
                time: DateTime.now(),
                host: '${dg.address.host}:${dg.port}',
                type: type,
              );
              Logger.print(dataEC.toString(), safeToDisk: true);
              if(type == TypeDataRcv.multi){
                Settings.remoteAddressExt = dg.address.address;
              }
              if(                  type == TypeDataRcv.multi
                  && dg.address.address == Settings.remoteAddress) {
                serviceEC.add((null, dataEC));
              }
              // stackDEC.add(dataEC);
              // final dataChart = ChartDataValue.fromEnvironmentalConditions(dataEC);
              // Logger.print(dataChart.toString());
              // stackCDV.add(dataChart);
            } on EnvironmentalConditionsException catch(e){
              Logger.print(e.errorMessage(), name: 'err',  error: true, safeToDisk: true);
            } on Exception catch(e, t){
              Logger.print(e.toString(), name: 'err',  error: true, safeToDisk: true);
              Logger.print(t.toString(), name: 'err',  error: true, safeToDisk: true);
            }
          }
          udpSocket.close();
        }
      },
        onDone: udpSocket.close,
        onError: onError,
      );
    } on Exception catch(e,t){
               Logger.print('type:$type: Error listen Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error listen Socket'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error listen Socket with:\n$e\n$t'
      );
    }
  }

  Future<void> _startRcvUdp({
    bool broadcastEnabled = true,
    String key = Constants.key
  }) async {
    try {
      if(!(await networkInfo.isConnected)) {
        Logger.print('${DateTime.now()}:UDPClientSenderReceiver: No Broadcast Device');
        serviceEC.add((const ServerFailure(errorMessage: 'No Broadcast Device'), null));
        Settings.remoteAddressExt = null;
        return;
      }
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
               Logger.print('type:$type: Error startRcvUdp Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error startRcvUdp Socket'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error startRcvUdp Socket with:\n$e\n$t'
      );
    }
  }

  //From Stream
  Future<void> run({
    bool broadcastEnabled = true
  }) async {
    try {
      await _startRcvUdp(broadcastEnabled: broadcastEnabled);
      _timer = Timer.periodic(periodic, (timer) async {
          try {
            await _startRcvUdp(broadcastEnabled: broadcastEnabled);
          }  on UDPClientSenderReceiverException catch(e, t) {
            Logger.print('type:$type: Error run Socket with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
            serviceEC.add((const ServerFailure(errorMessage: 'Error run Socket'), null));
          }
        },
      );
    } on Exception catch(e, t) {
               Logger.print('type:$type: Error run Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((const ServerFailure(errorMessage: 'Error run Socket'), null));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error run Socket with:\n$e\n$t'
      );
    }
  }

  void dispose(){
    _timer?.cancel();
    serviceEC.dispose();
  }
}
