import 'dart:convert';

import 'package:scrapy/scrapy.dart';

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
  factory Quote.fromJson(String str) => Quote.fromMap(json.decode(str));
  factory Quote.fromMap(Map<String, dynamic> json) => new Quote(
        quote: json["quote"] == null ? null : json["quote"],
      );
}

class Quotes extends Items {
  final List<Quote> items;
  Quotes({
    this.items,
  });
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  static Type typeOf<T>() => T;
  factory Quotes.fromJson(String str) => Quotes.fromMap(json.decode(str));
  factory Quotes.fromMap(Map<String, dynamic> json) => new Quotes(
        items: json["items"] == null
            ? null
            : new List<Quote>.from(json["items"].map((x) => Quote.fromMap(x))),
      );
}
