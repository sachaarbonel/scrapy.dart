import 'dart:async';

import 'package:dio/dio.dart';

abstract class Spider {
  String name;
  List<String> start_urls;
  Spider({this.name, this.start_urls});

  Future<Response> Request(List<String> start_urls) {
    return Dio().get(start_urls[0]);
  }
}
