import 'package:flutter/material.dart';
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/main_app_bar.dart';
import 'package:shopping/widgets/products_grid.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ProductsListScreen extends StatefulWidget {
  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final _showOnlyfav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar("Products"),
      drawer: const MyDrawer(),
      body: ProductsGrid(_showOnlyfav),
    );
  }
}
