import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

void main() async {
  final recvPort = ReceivePort();

  await Isolate.spawn<SendPort>((port) {
    if (kDebugMode) print('[2] received port');

    final recvMsg = ReceivePort();

    port.send(recvMsg.sendPort);

    if (kDebugMode)print('[2] sent my port');

    recvMsg.listen((message) {
      if (message is Animal) {
        if (kDebugMode) print('[2] Received ${message.name}');
      }
    });
  }, recvPort.sendPort);
  final first = await recvPort.first;
  final sendPort = (first is SendPort)?first:null;

  if (kDebugMode)print('[1] Sending bar');
  sendPort?.send(Animal('Bar'));

  if (kDebugMode)print('[1] Sending test');
  sendPort?.send(Animal('Test'));

  sleep(const Duration(seconds: 5));

  exit(0);
}

class Animal {
  final String _name;

  String get name => _name;

  Animal(this._name);
}
