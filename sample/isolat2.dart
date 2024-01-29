import 'dart:io';
import 'dart:isolate';

void main() async {
  final recvPort = ReceivePort();

  await Isolate.spawn<SendPort>((port) {
    print('[2] received port');

    final recvMsg = ReceivePort();

    port.send(recvMsg.sendPort);

    print('[2] sent my port');

    recvMsg.listen((message) {
      print('[2] Received ${message.name}');
    });
  }, recvPort.sendPort);

  final sendPort = await recvPort.first;

  print('[1] Sending bar');
  sendPort.send(Animal("Bar"));

  print('[1] Sending test');
  sendPort.send(Animal("Test"));

  sleep(const Duration(seconds: 5));

  exit(0);
}

class Animal {
  final String name;

  Animal(this.name);
}
