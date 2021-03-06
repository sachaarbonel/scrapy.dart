import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:http/http.dart';

import 'items.dart';


abstract class Spider<T extends Item, U extends Items> {
  // not used
  List<Future<Response>> futures = <Future<Response>>[];
  // not used
  U? items;
  // will either be the cache passed or empty mutable list
  late List<T> _cache;
  final String path;
  final List<String> startUrls;
  final Client client;

  Spider({
    required this.path,
    required this.startUrls,
    required this.client,
    List<T> cache = const [],
  }) {
    _cache = cache.isNotEmpty ? cache : <T>[];
  }

  // unused
  Future<Response> request(url) {
    return client.get(url);
  }

  Stream<T> get requests async* {
    final results =
        await Future.wait(startUrls.map((url) => client.get(Uri.parse(url))));
    for (var result in results) {
      yield* await save(transform(parse(result)));
    }
  }

  Future<void> startRequests() async {
    await for (T response in requests) {
      _cache.add(response);
    }
  }

  Future<void> saveResult() async {
    final items = Items(items: _cache);
    await File(path).writeAsString(json.encode(items));
  }

  Stream<String> parse(Response result) async* {}

  Stream<String> transform(Stream<String> parsed) async* {}

  Stream<T> save(Stream<String> transformed) async* {}
}
