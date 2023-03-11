import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  List<OrderItems> _orders = [];
  final String token;

  Order(this.token, this._orders);

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> getAndFetchOrders() async {
    final url =
        'https://shopping-ae175-default-rtdb.firebaseio.com/orders.json?auth=$token';
    final response = await http.get(
      Uri.parse(url),
    );

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItems> loadedOrders = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, order) {
      loadedOrders.insert(
        0,
        OrderItems(
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          id: orderId,
          products: (order['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  cartItemId: item['id'],
                  imageURl: item['imageURl'],
                  name: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder({
    required double total,
    required List<CartItem> cartProducts,
  }) async {
    final url =
        'https://shopping-ae175-default-rtdb.firebaseio.com/orders.json?auth=$token';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cartProduct) => {
                      'id': cartProduct.cartItemId,
                      'title': cartProduct.name,
                      'price': cartProduct.price,
                      'imageURl': cartProduct.imageURl,
                      'quantity': cartProduct.quantity,
                    })
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItems(
          amount: total,
          dateTime: timeStamp,
          id: json.decode(response.body)['name'],
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
