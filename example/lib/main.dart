import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrapy/scrapy.dart';
import 'package:html/parser.dart' show parse;

class QuoteStorage {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/data.json');
  }

  Future<String> getQuotes() async {
    File file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  }
}

void main() async {
  BlogSpider spider = BlogSpider();
  spider.name = "myspider";
  QuoteStorage storage = QuoteStorage();
  var path = await storage.localPath;
  spider.path = "$path/data.json";
  spider.start_urls = [
    "http://quotes.toscrape.com/page/7/",
    "http://quotes.toscrape.com/page/8/",
    "http://quotes.toscrape.com/page/9/"
  ];

  Stopwatch stopw = new Stopwatch()..start();

  await spider.start_requests();
  await spider.save_result();
  var elapsed = stopw.elapsed;

  print("the program took $elapsed");

  print(await storage.getQuotes());

  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: storage),
      //home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

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

class BlogSpider extends Spider<Quote, Quotes> {
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

class FlutterDemo extends StatefulWidget {
  final QuoteStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {

  @override
  void initState() {
    super.initState();
    // widget.storage.readCounter().then((int value) {
    //   setState(() {
    //     _counter = value;
    //   });
    // });
  }

  // Future<File> _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });

  //   // Write the variable as a string to the file.
  //   return widget.storage.writeCounter(_counter);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scrapy on flutter')),
      body: Center(
        child: FutureBuilder<Object>(
          future: widget.storage.getQuotes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            return snapshot.hasData ? Text(
              data
            ) : CircularProgressIndicator() ;
          }
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print("pressing button");
      //   },
      //   tooltip:
      //       'Launch scrapy to populate the screen with dummy scrapped data',
      //   child: Icon(Icons.launch),
      // ),
    );
  }
}
