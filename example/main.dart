import '../lib/scrapy.dart';
import 'package:dio/dio.dart';

class BlogSpider extends Spider {
  @override
  void set name(String _name) {
    super.name = _name;
  }

  @override
  void set start_urls(List<String> _start_urls) {
    super.start_urls = _start_urls;
  }

  @override
  String get name => super.name;

  @override
  List<String> get start_urls => super.start_urls;

  Future<List<Response>> start_requests() async {
    List<Response> responses = <Response>[];
    await for (Response response in Requests) {
      responses.add(response);
    }
    return responses;
  }

  Future<List<Response>> start_requests2() async {
    List<Response> responses;
    responses = await Requests2();
    return responses;
  }
}

main() {
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  spider.start_urls = [
    "http://quotes.toscrape.com/page/1/",
    "http://quotes.toscrape.com/page/2/",
    "http://quotes.toscrape.com/page/3/"
  ];
  Stopwatch stopw1 = new Stopwatch()..start();
  spider
      .start_requests()
      .then((List<Response> val) => val.forEach((Response res) {
            res.data.toString();
          }));

  var elapsed1 = stopw1.elapsed;
  //print('start_requests1() executed in ${stopw1.elapsed}');
  stopw1.stop();

  Stopwatch stopw2 = new Stopwatch()..start();
  spider
      .start_requests2()
      .then((List<Response> val) => val.forEach((Response r) {
            //print(r.data.toString());
            r.data.toString();
          }));
  var elapsed2 = stopw2.elapsed;
  //print('start_requests2() executed in ${stopw2.elapsed}');
  stopw2.stop();
  print("requests2 $elapsed2, requests1 $elapsed1");
}
