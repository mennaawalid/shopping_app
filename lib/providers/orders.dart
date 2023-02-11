import 'package:flutter/material.dart';
import 'package:shopping/providers/cart.dart';

class OrderItems {
  final String? id;
  final double? amount;
  final DateTime? dateTime;
  final List<CartItem>? products;

  OrderItems(
      {required this.amount,
      required this.dateTime,
      required this.id,
      required this.products});
}

class Order with ChangeNotifier {
  final List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  void addOrder({
    required double total,
    required List<CartItem> cartProducts,
  }) {
    _orders.insert(
        0,
        OrderItems(
            amount: total,
            dateTime: DateTime.now(),
            id: DateTime.now().toString(),
            products: cartProducts));
    notifyListeners();
  }
}
