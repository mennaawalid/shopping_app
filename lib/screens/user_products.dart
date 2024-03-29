import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_products_item.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products_screen';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts(true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await Provider.of<Products>(context, listen: false)
                    .fetchAndSetProducts(true);
              },
              child: Consumer<Products>(
                builder: (context, productData, _) {
                  return ListView.separated(
                      itemBuilder: (_, i) {
                        return UserProductItem(
                            id: productData.items[i].id,
                            imageURL: productData.items[i].imageURl,
                            name: productData.items[i].name);
                      },
                      separatorBuilder: ((_, index) {
                        return const Divider();
                      }),
                      itemCount: productData.items.length);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
