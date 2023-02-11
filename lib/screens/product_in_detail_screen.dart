import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/products_provider.dart';
import 'package:shopping/screens/cart_screen.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product_detail';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final product = Provider.of<Products>(context);

    SnackBar addedToCartSnackbar = SnackBar(
      content: const Text("Item added to cart!"),
      backgroundColor: Colors.brown,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          textColor: ColorPalettes.light,
          label: "GO TO CART!",
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          }),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: ColorPalettes.darker),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 184, 43, 43),
        title: Text(loadedProduct.name!,
            style: const TextStyle(
              color: ColorPalettes.darker,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Hero(
                  tag: productId,
                  child: CachedNetworkImage(
                    fit: BoxFit.scaleDown,
                    imageUrl: loadedProduct.imageURl!,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      overflow: TextOverflow.fade,
                      loadedProduct.description!,
                      style: const TextStyle(
                        letterSpacing: 0.9,
                        color: ColorPalettes.darker,
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "\$${loadedProduct.price!}",
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          color: ColorPalettes.darker,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: loadedProduct.isFavorite == false
                  ? const Color.fromARGB(255, 162, 153, 153)
                  : const Color.fromARGB(255, 247, 170, 196),
              size: 30.0,
            ),
            onPressed: () {
              loadedProduct.addAndRemoveFromFavs();

              if (loadedProduct.isFavorite == true) {
                product.addToFavs(loadedProduct.id!);
              } else {
                product.removeFromFavs(loadedProduct.id!);
              }
            },
          ),
          Expanded(
            child: ElevatedButton(
              child: const Text(
                "ADD TO CART",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                cart.addToCart(
                    imageURL: loadedProduct.imageURl!,
                    name: loadedProduct.name!,
                    productId: loadedProduct.id!,
                    price: loadedProduct.price!);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(addedToCartSnackbar);
              },
            ),
          ),
        ],
      ),
    );
  }
}
