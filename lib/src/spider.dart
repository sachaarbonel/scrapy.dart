import 'dart:async';
import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'items.dart';

abstract class Spider<T extends Item, U extends Items> {
  List<Future<Response>> futures = <Future<Response>>[];
  String name;
  List<T> cache;
  U items;
  List<String> start_urls;
  Spider({this.name, this.start_urls, this.cache}) {
    cache = <T>[];
  }

  Future<Response> Request(url) {
    return Dio().get(url);
  }

  Stream<T> get Requests async* {
    Dio dio = Dio();

    for (var url in start_urls) {
      futures.add(dio.get(url));
    }
    List<Response> results = await Future.wait(futures);
    for (var result in results) {
      yield* await Save(Transform(Parse(result)));
    }
  }

  void start_requests() async {
    await for (T response in Requests) {
      cache.add(response);
    }
  }

  void save_result() async {
    Items items = new Items(items: cache);
    await File('data.json').writeAsString(jsonEncode(items));
  }

  Stream<String> Parse(Response result) async* {}

  Stream<String> Transform(Stream<String> parsed) async* {}

  Stream<T> Save(Stream<String> transformed) async* {}
}
