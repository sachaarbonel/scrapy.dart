import '../lib/scrapy.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

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

  Stream<String> Parse(Response response) async* {
    var document = parse(response.data.toString());
    var nodes = document.querySelectorAll("div.quote> span.text");

    for (var node in nodes) {
      yield node.innerHtml;
    }
  }
}

main() async {
  Stopwatch stopw1 = new Stopwatch()..start();
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  spider.start_urls = [
    "http://quotes.toscrape.com/page/1/",
    "http://quotes.toscrape.com/page/2/",
    "http://quotes.toscrape.com/page/3/"
  ];

  await spider.start_requests();
  print(await spider.responses);
  var elapsed1 = stopw1.elapsed;
  print('start_requests() executed in ${elapsed1}');
  stopw1.stop();
}
