import 'dart:async';

import 'package:dio/dio.dart';

abstract class Spider {
  String name;
  List<String> cache = <String>[];
  List<String> start_urls;
  Spider({this.name, this.start_urls});

  Future<Response> Request(url) {
    return Dio().get(url);
  }

  // Stream<Response> get Requests async* {
  //   for (var url in start_urls) {
  //     yield await Request(url);
  //   }
  // }

  Stream<String> get Requests async* {
    Dio dio = Dio();
    List<Future<Response>> listOfFutures = <Future<Response>>[];
    for (var url in start_urls) {
      listOfFutures.add(dio.get(url));
    }
    List<Response> results = await Future.wait(listOfFutures);
    for (var result in results) {
      yield* await Parse(result);
    }
  }

  void start_requests() async {
    await for (String response in Requests) {
      cache.add(response);
    }
  }

  Stream<String> Parse(Response result) {}
}
