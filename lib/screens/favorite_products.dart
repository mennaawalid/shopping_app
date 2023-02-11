import 'package:flutter/material.dart';
import 'package:shopping/widgets/products_grid.dart';

import '../constants.dart';

bool _showfav = true;

class FavoriteProductsList extends StatelessWidget {
  static const routeName = '/fav_products';

  const FavoriteProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: ColorPalettes.darker),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 184, 43, 43),
        title: const Text("Favorite Products",
            style: TextStyle(
              color: ColorPalettes.darker,
            )),
      ),
      body: ProductsGrid(_showfav),
    );
  }
}
