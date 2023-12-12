import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/receive_data.txt');
}

Future<File> _writeCounter(String data) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString('$data\n');
}

Future<String> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } on Exception catch (e) {
    // If encountering an error, return 0
    return '';
  }
}
