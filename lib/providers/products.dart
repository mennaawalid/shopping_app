import 'package:flutter/material.dart';

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

  void addAndRemoveFromFavs() {
    isFavorite = !isFavorite!;
    notifyListeners();
  }
}
