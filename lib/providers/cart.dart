import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  final String? cartItemId;
  final String? name;
  final double? price;
  final String? imageURl;
  final int? quantity;

  CartItem(
      {required this.cartItemId,
      required this.imageURl,
      required this.name,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  int get itemCount {
    int count = 0;
    for (var v in _items.values) {
      count = count + v.quantity!;
    }
    return count;
  }

  double get totalPrice {
    double total = 0.0;
    for (var v in _items.values) {
      total += v.price! * v.quantity!;
    }
    return total;
  }

  void addToCart(
      {required String productId,
      required String name,
      required double price,
      required String imageURL}) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              cartItemId: existingCartItem.cartItemId,
              imageURl: existingCartItem.imageURl,
              name: existingCartItem.name,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity! + 1));
      notifyListeners();
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              cartItemId: DateTime.now().toString(),
              imageURl: imageURL,
              name: name,
              price: price,
              quantity: 1));
      notifyListeners();
    }
  }

  removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  decreaseQuantityOrRemove(String productId) {
    if ((!_items.containsKey(productId))) {
      return;
    }
    if (_items[productId]!.quantity! > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              cartItemId: existingCartItem.cartItemId,
              imageURl: existingCartItem.imageURl,
              name: existingCartItem.name,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity! - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
