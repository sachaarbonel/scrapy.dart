import 'dart:io';

import 'package:path_provider/path_provider.dart';

class QuoteStorage {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/data.json');
  }

  Future<String> getQuotes() async {
    File file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  }
}
