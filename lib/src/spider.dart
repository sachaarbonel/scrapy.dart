import 'dart:async';

import 'package:dio/dio.dart';

abstract class Spider<T> {
  String name;
  List<T> cache;
  List<String> start_urls;
  Spider({this.name, this.start_urls, this.cache});

  Future<Response> Request(url) {
    return Dio().get(url);
  }

  Stream<T> get Requests async* {
    Dio dio = Dio();
    List<Future<Response>> listOfFutures = <Future<Response>>[];
    for (var url in start_urls) {
      listOfFutures.add(dio.get(url));
    }
    List<Response> results = await Future.wait(listOfFutures);
    for (var result in results) {
      yield* await Save(Transform(Parse(result)));
    }
  }

  void start_requests() async {
    await for (T response in Requests) {
      cache.add(response);
    }
  }

  Stream<String> Parse(Response result) async* {}

  Stream<String> Transform(Stream<String> parsed) async* {}

  Stream<T> Save(Stream<String> transformed) async* {}
}
