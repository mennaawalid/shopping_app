import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/screens/cart_screen.dart';
import 'package:shopping/screens/favorite_products.dart';

enum Value { all, favs }

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  // ignore: use_key_in_widget_constructors
  const MainAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.brown),
      elevation: 0,
      backgroundColor: const Color.fromARGB(0, 184, 43, 43),
      title: Center(
          child: Text(title!,
              style: const TextStyle(
                color: ColorPalettes.darker,
              ))),
      actions: [
        // IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(ProductsListScreen.routeName);
        //     },
        //     color: ColorPalettes.darker,
        //     icon: const Icon(Icons.home_outlined)),
        IconButton(
          color: ColorPalettes.darker,
          onPressed: () {
            Navigator.of(context).pushNamed(FavoriteProductsList.routeName);
          },
          icon: const Icon(Icons.favorite_border),
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: ColorPalettes.darker,
                )),
            Consumer<Cart>(
              builder: (context, cart, _) {
                return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: ColorPalettes.dark,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      child: Text(
                        (cart.itemCount.toString()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ));
                // Container(
                //     constraints: const BoxConstraints(),
                //     decoration: const BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: ColorPalettes.dark,
                //     ),
                //     padding: const EdgeInsets.all(5),
                //     child: Text(cart.itemCount.toString()));
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
