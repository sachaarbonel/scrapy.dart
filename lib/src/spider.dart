import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:dio/dio.dart';

import 'items.dart';

abstract class Spider<T extends Item, U extends Items> {
  List<Future<Response>> futures = <Future<Response>>[];
  String name;
  List<T> cache;
  U items;
  String path;
  List<String> startUrls;
  Spider({this.name, this.startUrls, this.cache}) {
    cache = <T>[];
  }

  Future<Response> request(url) {
    return Dio().get(url);
  }

  Stream<T> get requests async* {
    final dio = Dio();

    for (var url in startUrls) {
      futures.add(dio.get(url));
    }
    final results = await Future.wait(futures);
    for (var result in results) {
      yield* await save(transform(parse(result)));
    }
  }

  Future<void> startRequests() async {
    await for (T response in requests) {
      cache.add(response);
    }
  }

  Future<void> saveResult() async {
    final items = Items(items: cache);
    await File(path).writeAsString(json.encode(items));
  }

  Stream<String> parse(Response result) async* {}

  Stream<String> transform(Stream<String> parsed) async* {}

  Stream<T> save(Stream<String> transformed) async* {}
}
