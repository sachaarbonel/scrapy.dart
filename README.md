# scrapy  
[scrapy](./packages/scrapy/) | [![pub package](https://img.shields.io/pub/v/scrapy.svg)](https://pub.dartlang.org/packages/scrapy)

Scrapy, a fast high-level web crawling & scraping framework for dart. 


## Getting started

```dart
import 'package:scrapy/scrapy.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

class Quote extends Item {
  String quote;
  Quote({this.quote});
  @override
  String toString() {
    return "Quote : { quote : $quote }";
  }

  Map<String, dynamic> toJson() => {
        "quote": quote == null ? null : quote,
      };
}

class Quotes<Quote> extends Items {
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

class BlogSpider extends Spider<Quote,Quotes> {
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

  Stopwatch stopw = new Stopwatch()..start();
  
  await spider.start_requests();
  await spider.save_result();
  var elapsed = stopw.elapsed;

  print("the program took $elapsed"); //the program took 0:00:00.279733
}

```

## TODOs
- [ ] tests
- [ ]  [link extractors](https://docs.scrapy.org/en/latest/topics/link-extractors.html)
- [ ] [download files](https://docs.scrapy.org/en/latest/topics/media-pipeline.html)