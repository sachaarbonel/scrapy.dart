import './model.dart';
import './spider.dart';
import './storage.dart';
import 'package:flutter/material.dart';

void main() async {
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  QuoteStorage storage = QuoteStorage();
  var path = await storage.localPath;
  spider.path = "$path/data.json";
  spider.startUrls = [
    "http://quotes.toscrape.com/page/7/",
    "http://quotes.toscrape.com/page/8/",
    "http://quotes.toscrape.com/page/9/"
  ];

  Stopwatch stopw = new Stopwatch()..start();

  await spider.startRequests();
  await spider.saveResult();
  var elapsed = stopw.elapsed;

  print("the program took $elapsed");

  print(await storage.getQuotes());

  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: storage),
    ),
  );
}

class FlutterDemo extends StatelessWidget {
  final QuoteStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scrapy on flutter')),
      body: Center(
        child: FutureBuilder(
            future: storage.getQuotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        Quotes data = Quotes.fromJson(snapshot.data);
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data.items[index].quote),
                        ));
                      },
                    )
                  : CircularProgressIndicator();
            }),
      ),
    );
  }
}
