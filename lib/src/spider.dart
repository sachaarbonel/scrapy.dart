import 'dart:async';

import 'package:dio/dio.dart';

abstract class Spider {
  String name;
  List<String> cache;
  List<String> start_urls;
  Spider({this.name, this.start_urls, this.cache});

  Future<Response> Request(url) {
    return Dio().get(url);
  }

  Stream<String> get Requests async* {
    Dio dio = Dio();
    List<Future<Response>> listOfFutures = <Future<Response>>[];
    for (var url in start_urls) {
      listOfFutures.add(dio.get(url));
    }
    List<Response> results = await Future.wait(listOfFutures);
    for (var result in results) {
      yield* await Transform(Parse(result));
    }
  }

  void start_requests() async {
    await for (String response in Requests) {
      cache.add(response);
    }
  }

  Stream<String> Parse(Response result) {}

  Stream<String> Transform(Stream<String> result) {}
}
