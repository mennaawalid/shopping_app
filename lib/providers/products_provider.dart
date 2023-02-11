import 'package:flutter/material.dart';
import 'package:shopping/providers/products.dart';

class Products with ChangeNotifier {
  final List<ProductInfo> _items = [
    ProductInfo(
        id: "F1",
        name: "black handbag, big - leather",
        price: 500.00,
        imageURl:
            "https://cdn.pixabay.com/photo/2015/08/10/20/14/handbag-883113_960_720.jpg",
        description: "black shoulder bag, leather and very nice"),
    ProductInfo(
        id: "F2",
        name: "Keyboard",
        price: 250.50,
        imageURl:
            "https://cdn.pixabay.com/photo/2013/07/13/14/06/keyboard-162134_960_720.png",
        description: "white wired keyboard - english"),
    ProductInfo(
        id: "F3",
        name: "Bottle",
        price: 150.00,
        imageURl:
            "https://cdn.pixabay.com/photo/2022/06/30/04/25/bottle-7292903_960_720.jpg",
        description: "reusable bottle in 4 colors"),
    ProductInfo(
        id: "F4",
        name: "Headphones",
        price: 700.00,
        imageURl:
            "https://cdn.pixabay.com/photo/2013/07/13/12/17/headphone-159569_960_720.png",
        description: "black overear headphones"),
    ProductInfo(
      id: 'p1',
      name: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageURl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductInfo(
      id: 'p2',
      name: 'Trousers, black, straight leg style',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageURl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductInfo(
      id: 'p3',
      name: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageURl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductInfo(
      id: 'p4',
      name: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageURl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  final List<ProductInfo> _favItems = [];

  List<ProductInfo> get items {
    return [..._items];
  }

  List<ProductInfo> get favItems {
    return [..._favItems];
    // return _items.where((element) => element.isFavorite!).toList();
  }

  void addToFavs(String id) {
    ProductInfo value = findById(id);
    _favItems.add(value);
    notifyListeners();
  }

  void removeFromFavs(String id) {
    ProductInfo value = findById(id);
    _favItems.remove(value);
    notifyListeners();
  }

  ProductInfo findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct(ProductInfo product) {
    ProductInfo newProduct = ProductInfo(
        id: DateTime.now().toString(),
        name: product.name,
        description: product.description,
        price: product.price,
        imageURl: product.imageURl);
    _items.insert(0, newProduct); // adds to the beginning of the list
    notifyListeners();
  }

  void editProduct(ProductInfo newProduct) {
    final index = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    }
  }

  void removeProduct(String productID) {
    _items.removeWhere((prod) => prod.id == productID);
    notifyListeners();
  }
}
