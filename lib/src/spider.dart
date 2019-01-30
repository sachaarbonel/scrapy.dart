import 'dart:async';
import 'package:dio/dio.dart';

typedef FutureResponse(params);

abstract class Spider {
  List<String> responses = <String>[];
  String name;
  List<String> start_urls;
  Spider({this.name, this.start_urls});

  Future<Response> Request(url) {
    return Dio().get(url);
  }

  Stream<String> get Requests async* {
    for (var url in start_urls) {
      yield* await Parse(await Request(url));
    }
  }

  void start_requests() async {
    await for (String response in Requests) {
      responses.add(response);
    }
  }

  Stream<String> Parse(Response response) {}
}
