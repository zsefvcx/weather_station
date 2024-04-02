import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weather_widget/core/core.dart';

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
  // Type data receiver
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
               serviceEC.add((
                 failure: ServerFailure(
                     errorMessage: '${DateTime.now()}:Error bind Socket'
                 ),
                 dataEnv: null,
               ));
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
          serviceEC.add((
            failure: ServerFailure(
                errorMessage: '${DateTime.now()}:Time Out Received'
            ),
            dataEnv: null,
          ));
          sink.close();
        },
      );
      return streamController;
    } on Exception catch(e, t){
               Logger.print('type:$type: Error timeOut Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((
                 failure: ServerFailure(
                     errorMessage: '${DateTime.now()}:Error timeOut Socket'
                 ),
                 dataEnv: null,
               ));
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
               serviceEC.add((
                 failure: ServerFailure(
                     errorMessage:'${DateTime.now()}:Error send Socket'
                 ),
                 dataEnv: null,
               ));
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
               serviceEC.add((
                 failure: ServerFailure(
                     errorMessage: '${DateTime.now()}:Error streamController'
                 ),
                 dataEnv: null,
               ));
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
              serviceEC.add((
                failure: ServerFailure(
                    errorMessage: '${DateTime.now()}:Error key message'
                ),
                dataEnv: null,
              ));
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
              // if(                  type == TypeDataRcv.multi
              //     && (dg.address.address == Settings.remoteAddress
              //       ||dg.address.address == Settings.remoteAddress2
              //     )
              // ) {
                serviceEC.add((
                  failure: null,
                  dataEnv: dataEC,
                ));
              //}
              // stackDEC.add(dataEC);
              // final dataChart = ChartDataValue.fromEnvironmentalConditions(dataEC);
              // Logger.print(dataChart.toString());
              // stackCDV.add(dataChart);
            } on EnvironmentalConditionsException catch(e){
              Logger.print(e.toString(), name: 'err',  error: true, safeToDisk: true);
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
               serviceEC.add((
                 failure: ServerFailure(
                     errorMessage: '${DateTime.now()}:Error listen Socket'
                 ),
                 dataEnv: null,
               ));
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
      Logger.print('_startRcvUdp type:$type address:$address', level: 1);
      if(!(await networkInfo.isConnected)) {
        Logger.print('${DateTime.now()}:type:$type:UDPClientSenderReceiver: No Broadcast Device');
        serviceEC.add((
          failure: const ServerFailure(
              errorMessage: 'No Broadcast Device'
          ),
          dataEnv: null,
        ));
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
               serviceEC.add((
                 failure: ServerFailure(
                     errorMessage: '${DateTime.now()}:Error startRcvUdp Socket'
                 ),
                 dataEnv: null,
               ));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error startRcvUdp Socket with:\n$e\n$t'
      );
    }
  }

  Future<void> _startProcess({
    bool broadcastEnabled = true
  }) async {
    try {
      await _startRcvUdp(broadcastEnabled: broadcastEnabled);
    }  on UDPClientSenderReceiverException catch(e, t) {
      Logger.print('type:$type: Error run Socket with:\n$e\n$t', error: true, name: 'err', safeToDisk: true);
      serviceEC.add((
        failure: ServerFailure(
            errorMessage: '${DateTime.now()}:Error run Socket'
        ),
        dataEnv: null,
      ));
    }
  }

  ///Запустить Stream
  Future<void> run({
    bool broadcastEnabled = true
  }) async {
    try {
      await _startRcvUdp(broadcastEnabled: broadcastEnabled);
      _timer = Timer.periodic(periodic, (timer) async {
          await _startProcess(broadcastEnabled: broadcastEnabled);
        },
      );
    } on Exception catch(e, t) {
               Logger.print('type:$type: Error run Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((
                 failure: ServerFailure(errorMessage: '${DateTime.now()}:Error run Socket'
                 ),
                 dataEnv: null,
               ));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error run Socket with:\n$e\n$t'
      );
    }
  }

  ///запустить единожды
  Future<void> startSingle({
    bool broadcastEnabled = true
  }) async {
    try {
      await _startRcvUdp(broadcastEnabled: broadcastEnabled);
    } on Exception catch(e, t) {
      Logger.print('type:$type: Error run Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
      serviceEC.add((
        failure: ServerFailure(
            errorMessage: '${DateTime.now()}:Error run Socket'
        ),
        dataEnv: null,
      ));
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error run Socket with:\n$e\n$t'
      );
    }
  }

  ///Приостановить
  void suspend(){
    _timer?.cancel();
  }

  ///Разрушить
  void dispose(){
    _timer?.cancel();
    serviceEC.dispose();
  }
}
