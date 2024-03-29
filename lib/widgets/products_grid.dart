import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import 'one_product.dart';

class ProductsGrid extends StatelessWidget {
  final bool favornot;
  const ProductsGrid(this.favornot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = favornot ? productsData.favItems : productsData.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: const ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
