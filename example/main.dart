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

  Future<String> start_requests() async {
    Response response;
    response = await Request(start_urls);
    return response.data.toString();
  }
}

main() {
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  spider.start_urls = ["http://quotes.toscrape.com/page/1/"];
  spider.start_requests().then((String val) => print(val));
}
