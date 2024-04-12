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
  /// Статус запуска
  bool isRunning = false;

  UDPClientSenderReceiver({
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
      Logger.print('_bind type:$type address:$address', level: 1);
      final serverAddress = (await InternetAddress.lookup(address)).first;
      final udpSocket = await RawDatagramSocket.bind(
          serverAddress.type == InternetAddressType.IPv6
              ? InternetAddress.anyIPv6
              : InternetAddress.anyIPv4, bindPort);
      return udpSocket;
  }

  Stream<RawSocketEvent> _timeOut({required RawDatagramSocket udpSocket}){
      Logger.print('_timeOut => streamController type:$type address:$address', level: 1);
      final streamController = udpSocket.timeout(timeLimit,
        onTimeout: (sink) {
          Logger.print('${DateTime.now()}:Time Out Received. type:$type', error: true);
          serviceEC.add((
            failure: ServerFailure(
                errorMessage: '${DateTime.now()}:Time Out Received'
            ),
            dataEnv: null,
          ), status: isRunning);
          sink.close();
        },

      );
      return streamController;
  }

  Future<int?> _send(String key, {required RawDatagramSocket udpSocket}) async {
      Logger.print('_send type:$type key:$key');
      final serverAddress = (await InternetAddress.lookup(address)).first;
      return udpSocket.send(utf8.encode(key), serverAddress, senderPort);
  }

  StreamSubscription<RawSocketEvent> _listen({
    required Stream<RawSocketEvent> streamController,
    required RawDatagramSocket udpSocket
  }){
    Logger.print('_listen => streamController type:$type address:$address', level: 1);
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
              ), status: isRunning);
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
                serviceEC.add((
                  failure: null,
                  dataEnv: dataEC,
                ), status: isRunning);
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
      );
  }

  Future<void> _startRcvUdp({
    bool broadcastEnabled = true,
    String key = Constants.key
  }) async {
      Logger.print('_startRcvUdp type:$type address:$address', level: 1);
      final udpSocket = await _bind();
      try {
        final streamController = _timeOut(udpSocket: udpSocket);
        udpSocket.broadcastEnabled = broadcastEnabled;
        final streamSubscription = _listen(
          streamController: streamController,
          udpSocket: udpSocket,
        );
        if (bindPort == 0) await _send(key, udpSocket: udpSocket);
        await streamSubscription.asFuture<void>();
        await streamSubscription.cancel();
      } finally {
        udpSocket.close();
      }
  }

  ///Запустить
  Future<void> run({
    ///Широковещательный пакет. Прием.
    bool broadcastEnabled = true,
  }) async {
    try {
      Logger.print('RUN type:$type address:$address isRunning:$isRunning', level: 1);
      //число попыток = (Время сна устройства * 2)/5сек
      var attempt = Constants.timeSleepDevices~/5;
      //Запрос уже запущен и не надо сюда лезть
      if (isRunning) return;
      //Не запущенно запускаем....
      isRunning = true;
      await Future.doWhile(() async {
        attempt--;
        if(!(await networkInfo.isConnected)){
          Logger.print('${DateTime.now()}:type:$type:UDPClientSenderReceiver: No Broadcast Device: status:$attempt');
          await Future.delayed(const Duration(seconds: 5));
          attempt--;
          //результат - закончились попытки
          return attempt>=0 && isRunning;
        } else {
          //доступно можно опрашивать
          attempt = -100;
          return false;
        }


      }).whenComplete(() async {
        Logger.print('${DateTime.now()}:type:$type:isRunning:$isRunning:UDPClientSenderReceiver: Broadcast Search Complete status:$attempt:');
        if (attempt == -100 || isRunning) {
          await _startRcvUdp(broadcastEnabled: broadcastEnabled);
        } else {
          serviceEC.add((
            failure: const ServerFailure(
              errorMessage: 'No Broadcast Device'
            ),
            dataEnv: null,
          ), status: isRunning);
        }
        isRunning = false;
      });
      // if(!(await networkInfo.isConnected)) {
      //   Logger.print('${DateTime.now()}:type:$type:UDPClientSenderReceiver: No Broadcast Device');

      //   Settings.remoteAddressExt = null;
      //   return;
      // }



    } on Exception catch(e, t) {
               Logger.print('type:$type: Error run Socket with:\n$e\n$t', name: 'err',  error: true,  safeToDisk: true,);
               serviceEC.add((
                 failure: ServerFailure(errorMessage: '${DateTime.now()}:Error run Socket'
                 ),
                 dataEnv: null,
               ),status: isRunning);
               isRunning = false;
      throw UDPClientSenderReceiverException(
          errorMessage: 'type:$type: Error run Socket with:\n$e\n$t'
      );
    }
  }

  ///Разрушить
  void dispose(){
    isRunning = false;
    serviceEC.dispose();
  }
}
