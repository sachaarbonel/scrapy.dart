# scrapy

Scrapy, a fast high-level web crawling & scraping framework for dart. 


## Getting started

```dart
import '../lib/scrapy.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import './items.dart';

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
- [ ]  [link extractors](https://docs.scrapy.org/en/latest/topics/link-extractors.html)
- [ ] [download files](https://docs.scrapy.org/en/latest/topics/media-pipeline.html)