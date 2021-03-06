class Items<T extends Item> extends Object {
  List<T> items;
  Items({required this.items});

  Map<String, dynamic> toJson() {
    final result = <Map<String, dynamic>>[];
    items.forEach((T item) {
      result.add(item.toJson());
    });

    return {"items": result};
  }
}

abstract class Item extends Object {
  Map<String, dynamic> toJson();
}
