import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/cart.dart' show Cart;
import 'package:shopping/providers/orders.dart';
import 'package:shopping/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItem = cart.items;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: ColorPalettes.darker),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 184, 43, 43),
        title: const Text("Cart",
            style: TextStyle(
              color: ColorPalettes.darker,
            )),
      ),
      body: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Card(
                  elevation: 0,
                  child: Text(
                    "Total",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorPalettes.darker,
                        fontSize: 20),
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    "\$${cart.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: ColorPalettes.light,
                    ),
                  ),
                  backgroundColor: Colors.brown,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold)),
                  onPressed: (() {
                    if (cart.items.isNotEmpty) {
                      Provider.of<Order>(context, listen: false).addOrder(
                          total: cart.totalPrice,
                          cartProducts: cart.items.values.toList());
                      cart.clearCart();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "THE CART IS EMPTY, PLEASE ADD PRODUCT IF YOU WANT TO MAKE AN ORDER"),
                        backgroundColor: ColorPalettes.dark,
                        duration: Duration(seconds: 3),
                      ));
                    }
                  }),
                  child: const Text("ORDER NOW"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (cxt, i) {
                return ChangeNotifierProvider.value(
                  value: cartItem.values.toList()[i],
                  child: OneCartItem(productID: cartItem.keys.toList()[i]),
                );
              },
              itemCount: cartItem.length,
            ),
          ),
        ],
      ),
    );
  }
}
