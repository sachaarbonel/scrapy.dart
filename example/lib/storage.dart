import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'model.dart';

class QuoteStorage {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/data.json');
  }

  Future<Quotes> getQuotes() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    return Quotes.fromJson(contents);
  }
}
