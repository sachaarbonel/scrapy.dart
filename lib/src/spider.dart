import 'dart:async';

import 'package:dio/dio.dart';

typedef FutureResponse(params);

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

  Future<List<Response>> start_requests() async {
    List<Response> responses = <Response>[];
    await for (Response response in Requests) {
      responses.add(response);
    }
    return responses;
  }
}
