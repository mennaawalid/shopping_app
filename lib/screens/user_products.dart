import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/products_provider.dart';
import 'package:shopping/screens/edit_product_screen.dart';
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/user_products_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products_screen';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.brown),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 184, 43, 43),
        title: const Text(
          'My Products',
          style: TextStyle(
            color: ColorPalettes.darker,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts();
        },
        child: ListView.separated(
            itemBuilder: (_, i) {
              return UserProductItem(
                  id: productData.items[i].id,
                  imageURL: productData.items[i].imageURl,
                  name: productData.items[i].name);
            },
            separatorBuilder: ((_, index) {
              return const Divider();
            }),
            itemCount: productData.items.length),
      ),
    );
  }
}
