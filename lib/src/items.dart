class Items<T extends Item> extends Object {
  List<T> items;
  Items({this.items});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    items.forEach((T item) {
      result.add(item.toJson());
    });

    return {"items": result};
  }
}

abstract class Item extends Object {
  Map<String, dynamic> toJson();
}
