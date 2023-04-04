import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

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
                OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle:
            const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
      ),
      onPressed: widget.cart.items.isEmpty
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Order>(context, listen: false).addOrder(
                  total: widget.cart.totalPrice,
                  cartProducts: widget.cart.items.values.toList(),
                );
                widget.cart.clearCart();
              } catch (error) {
                await showDialog<Null>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Error!',
                    ),
                    content: const Text('Something went wrong!'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('okay'),
                      ),
                    ],
                  ),
                );
              }
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("ORDER NOW"),
    );
  }
}
