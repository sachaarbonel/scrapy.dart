import 'dart:convert';

import 'package:scrapy/scrapy.dart';

class Quote extends Item {
  String quote;
  Quote({required this.quote});
  @override
  String toString() {
    return "Quote : { quote : $quote }";
  }

  @override
  Map<String, dynamic> toJson() => {
        "quote": quote,
      };
  factory Quote.fromJson(String str) => Quote.fromMap(json.decode(str));
  factory Quote.fromMap(Map<String, dynamic> json) => Quote(
        quote: json["quote"] == null ? null : json["quote"],
      );
}

class Quotes extends Items {
  @override
  final List<Quote> items;
  Quotes({
    required this.items,
  }) : super(items: items);

  factory Quotes.fromJson(String str) => Quotes.fromMap(json.decode(str));
  factory Quotes.fromMap(Map<String, dynamic> json) => Quotes(
        items: json['items'] == null
            ? <Quote>[]
            : List<Quote>.from(json['items']!.map((x) => Quote.fromMap(x))),
      );
}
