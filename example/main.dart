import '../lib/scrapy.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class BlogSpider extends Spider {
  Stream<String> Parse(Response response) async* {
    var document = parse(response.data.toString());
    var nodes = document.querySelectorAll("div.quote> span.text");

    for (var node in nodes) {
      yield node.innerHtml;
    }
  }
}

main() async {
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  spider.start_urls = [
    "http://quotes.toscrape.com/page/1/",
    "http://quotes.toscrape.com/page/2/",
    "http://quotes.toscrape.com/page/3/"
  ];

  Stopwatch stopw2 = new Stopwatch()..start();
  await spider.start_requests();
  print(await spider.cache);
  var elapsed2 = stopw2.elapsed;

  print("requests2 $elapsed2");
}
