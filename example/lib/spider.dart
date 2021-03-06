import 'package:html/parser.dart' as html;
import 'package:http/http.dart';
import 'package:scrapy/scrapy.dart';

import 'model.dart';

class BlogSpider extends Spider<Quote, Quotes> {
  BlogSpider({
    required String path,
    required List<String> startUrls,
    required Client client,
  }) : super(
          path: path,
          startUrls: startUrls,
          client: client,
        );

  BlogSpider.existingCache({
    required String path,
    required List<String> startUrls,
    required List<Quote> cache,
    required Client client,
  }) : super(
          path: path,
          startUrls: startUrls,
          cache: cache,
          client: client,
        );

  @override
  Stream<String> parse(Response response) async* {
    final document = html.parse(response.body);
    final nodes = document.querySelectorAll("div.quote> span.text");

    for (var node in nodes) {
      yield node.innerHtml;
    }
  }

  @override
  Stream<String> transform(Stream<String> stream) async* {
    await for (String parsed in stream) {
      final transformed = parsed;
      yield transformed.substring(1, parsed.length - 1);
    }
  }

  @override
  Stream<Quote> save(Stream<String> stream) async* {
    await for (String transformed in stream) {
      final quote = Quote(quote: transformed);
      yield quote;
    }
  }
}
