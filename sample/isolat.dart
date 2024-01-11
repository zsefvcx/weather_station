// import 'dart:async';
// import 'dart:isolate';
//
// import 'package:flutter/foundation.dart';
//
// class ContinuousIsolator {
//   ContinuousIsolator(
//       {required int channel, required void Function(double) setCounter}) {
//     if (kDebugMode) {
//       print('Isolator initialisation');
//     }
//     _channel = channel;
//     _setCounter = setCounter;
//     spawn();
//   }
//   late int _channel; // The id of this isolate
//   late void Function(double)
//   _setCounter; // Callback function to set on-screen counter
//   late SendPort _port; // SendPort of child isolate to communicate with
//   late Isolate _isolate; // Pointer to child isolate
//   ReceivePort receivePort = ReceivePort(); // RecevierPort for this class
//
//   // Spawn a new isolate to complete the countdown (or up)
//   // channel = the number of the isolate
//   // counter = the value to count down from (or up to)
//   void spawn() {
//     if (kDebugMode) {
//       print('Isolator establishing receiver');
//     }
//     // Establish a listener for messages from the child
//     receivePort.listen((msg) {
//       // Unpack the map from the returned string (child sends a single map
//       // contained key: isolate id and value: message)
//       final map = Map<int, dynamic>.from(msg as Map<dynamic, dynamic>);
//
//       // There should be only one key:value pair received
//       for (final key in map.keys) {
//         msg = map[key]; // Extract the message
//       }
//
//       // If we have received a Sendport, then capture it to communicate with
//       if (msg is SendPort) {
//         _port = msg;
//       } else {
//         // Otherwise process the message
//         // If it contains 'END' then we need to terminate the isolate
//         switch (msg) {
//           case 'END':
//             _isolate.kill();
//             // Isolate has completed, then close this receiver port
//             receivePort.close();
//             break;
//           default:
//             _setCounter(msg as double); // Send message to display
//             break;
//         }
//       }
//     });
//
//     // Start the child isolate
//     Isolate.spawn(worker, {_channel: receivePort.sendPort}).then((isolate) {
//       _isolate = isolate; // Capture isolate so we can kill it later
//     });
//   }
//
//   // Class method to start the child isolate doing work (countdown timer)
//   void run() {
//     if (kDebugMode) {
//       print('Sending START to worker');
//     }
//     _port.send('START');
//   }
//
//   // Class method to stop the child isolate doing work (countdown timer)
//   void stop() {
//     if (kDebugMode) {
//       print('Sending STOP to worker');
//     }
//     _port.send('STOP');
//   }
//
//   // Class method to tell the child isolate to self-terminate
//   void end() {
//     _port.send('END'); // Send counter value to start countdown
//   }
// }
//
// // Child isolate function that is spawned by the parent class ContinuousIsolator
// // Called initially with single map of key: 'unique channel id' and value:
// // receiver port from the parent
// void worker(Map<int, dynamic> args) {
//   int? id; // Unique id number for this channel
//   final receivePort = ReceivePort(); // Receive port for this isolate
//   SendPort? sendPort; // Send port to communicate with the parent
//   const double start = 10000000; // Starting counter value
//   var counter = start; // The counter
//   const int chunkSize =
//   100; // The number of counter decrements/increments to process per 'chunk'
//   bool down = true; // Flag to show is counting 'down' (true) or 'up' (false)
//   bool run = false; // Flag to show if the isolate is running the computation
//
//   // Unpack the initial args to get the id and sendPort.
//   // There should be only one key:value pair
//   dynamic msg = '';
//   final map = Map<int, dynamic>.from(args);
//   for (var key in map.keys) {
//     id = key; // Extract the isolate id
//     msg = map[key]; // Extract the message
//   }
//   // The first message should contain the receivePort for the main isolate
//   if (msg is SendPort) {
//     sendPort = msg; // Capture sendport to communicate with the parent
//     if (kDebugMode) {
//       print('worker $id sending send port');
//     }
//     // Send the receiver port for this isolate to the parent
//     sendPort.send({id: receivePort.sendPort});
//   }
//
//   // Method to get the current counter value
//   double getCounter() {
//     return counter;
//   }
//
//   // Method to set the current counter value
//   void setCounter(double value) {
//     counter = value;
//   }
//
//   // Method to get the down flag value
//   bool getDown() {
//     return down;
//   }
//
//   // Method to set the down flag value
//   void setDown(bool value) {
//     down = value;
//   }
//
//   // This function does the main work of the isolate, ie the computation
//   Future<void> runChunk(
//       int chunkSize, // The number of loops to process for a given 'chunk'
//       bool Function() getDown, // Callback to get bool down value
//       void Function(bool) setDown, // Callback to set bool down value
//       double Function() getCounter, // Call back to get current counter value
//       void Function(double) setCounter) // Callback to set counter value
//   async {
//     const start = 10000000; // Starting value for the counter
//
//     // Count down (or up) the counter for chunkSize iterations
//     for (int i = 0; i < chunkSize; i++) {
//       // Counting down...
//       if (getDown()) {
//         setCounter(getCounter() - 1);
//         // If reached zero, flip the counting up
//         if (getCounter() < 0) setDown(!getDown());
//       } else {
//         // Counting up...
//         setCounter(getCounter() + 1);
//         // If reached start (max), flip the counting down
//         if (getCounter() > start) setDown(!getDown());
//       }
//       // Update the display every 1000 points
//       if ((getCounter() ~/ 1000) == getCounter() / 1000) {
//         sendPort!.send({id: getCounter()}); // Notify parent of the new value
//       }
//     }
//
//     // If the isolate is still running (parent hasn't sent 'STOP') then
//     // call this function again to iterate another chunk.  This gives the event
//     // queue a chance to process the 'STOP'command from the parent
//     if (run) {
//       // I assume Future.delayed adds call back onto the event queue
//       Future.delayed(Duration.zero, () {
//         runChunk(chunkSize, getDown, setDown, getCounter, setCounter);
//       });
//     }
//   }
//
//   // Establish listener for messages from the controller
//   if (kDebugMode) {
//     print('worker $id establishing listener');
//   }
//   receivePort.listen((msg) {
//     if (kDebugMode) {
//       print('worker $id has received $msg');
//     }
//     switch (msg) {
//       case 'START':
//       // Start the worker function running and set run = true
//         if (kDebugMode) {
//           print('Worker $id starting run');
//         }
//         run = true;
//         runChunk(chunkSize, getDown, setDown, getCounter, setCounter);
//       case 'STOP':
//       // Set run = false to stop the worker function
//         if (kDebugMode) {
//           print('Worker $id stopping run');
//         }
//         run = false;
//       case 'END':
//       // Inform parent that isolate is shutting down
//         sendPort?.send({id: msg});
//         receivePort.close(); // Close the receiver port
//       default:
//         break;
//     }
//   });
// }