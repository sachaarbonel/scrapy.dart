import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:http/http.dart';

import 'items.dart';

abstract class Spider<T extends Item, U extends Items> {
  List<Future<Response>> futures = <Future<Response>>[];
  String name;
  List<T> cache;
  Client client;
  U items;
  String path;
  List<String> startUrls;
  Spider({this.name, this.startUrls, this.cache, this.client}) {
    cache = <T>[];
  }

  Future<Response> request(url) {
    return client.get(url);
  }

  Stream<T> get requests async* {
    final results = await Future.wait(startUrls.map((url) => client.get(url)));
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
