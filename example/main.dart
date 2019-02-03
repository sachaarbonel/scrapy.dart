import '../lib/scrapy.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import './items.dart';
import 'dart:io' show File;
import 'dart:convert';

class BlogSpider extends Spider<Quote> {
  Stream<String> Parse(Response response) async* {
    var document = parse(response.data.toString());
    var nodes = document.querySelectorAll("div.quote> span.text");

    for (var node in nodes) {
      yield node.innerHtml;
    }
  }

  @override
  Stream<String> Transform(Stream<String> stream) async* {
    await for (String parsed in stream) {
      var transformed = parsed;
      yield transformed.substring(1, parsed.length - 1);
    }
  }

  @override
  Stream<Quote> Save(Stream<String> stream) async* {
    await for (String transformed in stream) {
      Quote quote = Quote(quote: transformed);
      yield quote;
    }
  }
}

main() async {
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  spider.start_urls = [
    "http://quotes.toscrape.com/page/7/",
    "http://quotes.toscrape.com/page/8/",
    "http://quotes.toscrape.com/page/9/"
  ];

  Stopwatch stopw2 = new Stopwatch()..start();
  spider.cache = <Quote>[];
  await spider.start_requests();
  List<Quote> cache = await spider.cache;
  Quotes quotes = Quotes(quotes: cache);
  await File('data.json').writeAsString(jsonEncode(quotes));
  var elapsed2 = stopw2.elapsed;

  print("requests2 $elapsed2");
}
