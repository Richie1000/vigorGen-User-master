import 'package:flutter/foundation.dart';

class LabCartItem {
  final String id;
  final String title;
  final double price;

  LabCartItem({
    @required this.id,
    @required this.price,
    @required this.title
  });
}

class LabCart with ChangeNotifier {
  Map<String, LabCartItem> _items = {};

  Map<String, LabCartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {

    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price;
    });
    return total;
  }

  void addLabItem(
    String productId,
    double price,
    String title,

  ){
    _items.putIfAbsent(
        productId,
        () => LabCartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
            ),
      );
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
      _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}