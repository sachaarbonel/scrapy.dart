import 'dart:async';

import 'package:dio/dio.dart';

abstract class Spider {
  String name;
  List<String> start_urls;
  Spider({this.name, this.start_urls});

  Future<Response> Request(url) {
    return Dio().get(url);
  }

  Stream<Response> get Requests async* {
    for (var url in start_urls) {
      yield await Request(url);
    }
  }

  Stream<Response> get Requests2 async* {
    Dio dio = Dio();
    var listOfFutures = <Future>[];
    for (var url in start_urls) {
      listOfFutures.add(dio.get(url));
    }
    var results = await Future.wait(listOfFutures);
    for (var result in results) {
      yield await result;
    }
  }
}
