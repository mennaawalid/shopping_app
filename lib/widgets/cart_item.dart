import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/cart.dart';

class OneCartItem extends StatelessWidget {
  final String? productID;
  const OneCartItem({Key? key, this.productID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartItem>(context);
    final cartAddorRemove = Provider.of<Cart>(context);
    return Dismissible(
      confirmDismiss: ((direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'Are you sure you want to delete this item from cart?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No'))
                ],
              );
            });
      }),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 5),
        alignment: Alignment.centerRight,
        color: ColorPalettes.dark,
        child: const Icon(
          Icons.delete,
          color: ColorPalettes.light,
          size: 25,
        ),
      ),
      key: ValueKey(cart.cartItemId),
      onDismissed: ((direction) {
        cartAddorRemove.removeFromCart(productID!);
      }),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: cart.imageURl!,
              ),
            ),
          ),
          title: Text(
            cart.name!,
            style: const TextStyle(
                color: ColorPalettes.darker, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Total: \$${(cart.price! * cart.quantity!)}",
              style: const TextStyle(color: ColorPalettes.dark)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  if (cart.quantity! == 1) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text(
                                'Are you sure you want to delete this item from cart?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  cartAddorRemove
                                      .decreaseQuantityOrRemove(productID!);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        });
                  } else {
                    cartAddorRemove.decreaseQuantityOrRemove(productID!);
                  }
                },
                icon: const Icon(Icons.remove),
                color: ColorPalettes.darker,
              ),
              Text(
                "${cart.quantity}",
                style: const TextStyle(color: ColorPalettes.dark),
              ),
              IconButton(
                onPressed: () {
                  cartAddorRemove.addToCart(
                      productId: productID!,
                      name: cart.name!,
                      price: cart.price!,
                      imageURL: cart.imageURl!);
                },
                icon: const Icon(Icons.add),
                color: ColorPalettes.darker,
              )
            ],
          ),
        ),
      ),
    );
  }
}
