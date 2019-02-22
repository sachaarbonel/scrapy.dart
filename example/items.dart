import '../lib/src/items.dart';

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
