import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import 'cart_screen.dart';

import '../providers/auth.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product_detail';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final authDetails = Provider.of<Auth>(context, listen: false);

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
      // appBar: AppBar(
      //   leading: const BackButton(color: ColorPalettes.darker),
      //   elevation: 0,
      //   backgroundColor: const Color.fromARGB(0, 184, 43, 43),
      //   title: Text(loadedProduct.name!,
      //       style: const TextStyle(
      //         color: ColorPalettes.darker,
      //       )),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.name!,
              ),
              background: Card(
                elevation: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Hero(
                    tag: productId,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: loadedProduct.imageURl!,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          maxLines: 3,
                          loadedProduct.description!,
                          style: const TextStyle(
                            letterSpacing: 0.9,
                            color: ColorPalettes.darker,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "\$${loadedProduct.price!}",
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              color: ColorPalettes.darker,
                              fontSize: 22,
                              fontWeight: FontWeight.w900),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
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
              loadedProduct.addAndRemoveFromFavs(
                  authDetails.token, authDetails.userId!);
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
                  price: loadedProduct.price!,
                );
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
