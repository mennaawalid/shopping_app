import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ProductInfo with ChangeNotifier {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageURl;
  bool? isFavorite;

  ProductInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURl,
    this.isFavorite = false,
  });

  Future<void> addAndRemoveFromFavs() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite!;
    notifyListeners();
    final url =
        'https://shopping-ae175-default-rtdb.firebaseio.com/products/$id.json';

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
