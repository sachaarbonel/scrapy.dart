import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'model.dart';
import 'spider.dart';
import 'storage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final startUrls = <String>[
    'https://quotes.toscrape.com/page/7/',
    'https://quotes.toscrape.com/page/8/',
    'https://quotes.toscrape.com/page/9/'
  ];
  final storage = QuoteStorage();
  final path = await storage.localPath;
  
  final spider = BlogSpider(
    path: '$path/data.json',
    startUrls: startUrls,
    client: Client(),
  );

  final stopw = Stopwatch()..start();

  await spider.startRequests();
  await spider.saveResult();
  final elapsed = stopw.elapsed;

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

  const FlutterDemo({Key? key, required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scrapy on flutter')),
      body: Center(
        child: FutureBuilder(
            future: storage.getQuotes(),
            builder: (context, AsyncSnapshot<Quotes> snapshot) {
              final quotes = snapshot.data;
              return quotes != null
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(quotes.items[index].quote),
                          ),
                        );
                      },
                    )
                  : const CircularProgressIndicator();
            }),
      ),
    );
  }
}
