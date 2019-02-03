class Quote extends Object {
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

class Quotes extends Object {
  List<Quote> quotes;

  Quotes({this.quotes});
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    quotes.forEach((Quote quote) {
      result.add(quote.toJson());
    });

    return {"quotes": result};
  }
}
