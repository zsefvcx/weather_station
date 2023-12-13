//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
//
//
// Future <void> sendUDPData() async {
//   final buffer = utf8.encode('foobar');
//   final socket = await RawDatagramSocket.bind(InternetAddress('192.168.100.13'), 0);  // My PC's IP
//   final streamController = socket.timeout(const Duration(seconds: 5), onTimeout: (sink) => sink.close());
//   socket.broadcastEnabled = true;
//
//   final streamSubscription = streamController.listen((rawSocketEvent) async {
//     final dg = socket.receive();
//     if (dg != null) {
//       if (kDebugMode) {
//         print('Received:');
//         print(utf8.decode(dg.data));
//       }
//     }
//     socket.close();
//   });
//
//   socket.send(buffer, InternetAddress('255.255.255.255'), 1234);
//
//   // Wait for the socket to be done listening for a response
//   await streamSubscription.asFuture<void>();
//   await streamSubscription.cancel();
// }
//
// Future <void> resvUDPData() async {
//
//   final socket = await RawDatagramSocket.bind(InternetAddress('192.168.100.13'), 8088);  // My PC's IP
//   final streamController = socket.timeout(const Duration(seconds: 5), onTimeout: (sink) => sink.close());
//   socket.broadcastEnabled = true;
//
//   final streamSubscription = streamController.listen((rawSocketEvent) async {
//     final dg = socket.receive();
//     if (dg != null) {
//       if (kDebugMode) {
//         print('Received:');
//         print(utf8.decode(dg.data));
//       }
//       socket.close();
//     }
//   },
//   onDone: socket.close,
//   );
//
//   // Wait for the socket to be done listening for a response
//   await streamSubscription.asFuture<void>();
//   await streamSubscription.cancel();
//   socket.close();
// }
//
// void main() async {
//   await sendUDPData();
//   while(true){
//     await resvUDPData();
//   }
// }
