import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping/providers/products.dart';
import 'package:shopping/providers/products_provider.dart';
import 'package:shopping/screens/product_in_detail_screen.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProductInfo>(context);
    final products = Provider.of<Products>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: GridTile(
          footer: Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            elevation: 0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name!,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                            fontSize: 17, color: ColorPalettes.darker),
                      ),
                      Text(
                        "\$${data.price!.toString()}",
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                            color: ColorPalettes.dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: ColorPalettes.dark,
                  ),
                  onPressed: () {
                    cart.addToCart(
                        imageURL: data.imageURl!,
                        name: data.name!,
                        productId: data.id!,
                        price: data.price!);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Item added to cart!"),
                        backgroundColor: Colors.brown,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                            textColor: ColorPalettes.light,
                            label: "UNDO!",
                            onPressed: () {
                              cart.decreaseQuantityOrRemove(data.id!);
                            }),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          header: GridTileBar(
            leading: Card(
              shadowColor: Colors.white,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(3, 5, 3, 3),
                //  padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.favorite,
                  color: data.isFavorite == false
                      ? const Color.fromARGB(255, 162, 153, 153)
                      : const Color.fromARGB(255, 247, 170, 196),
                  // ColorPalettes.dark,
                ),
                onPressed: () {
                  data.addAndRemoveFromFavs();

                  if (data.isFavorite == true) {
                    products.addToFavs(data.id!);
                  } else {
                    products.removeFromFavs(data.id!);
                  }
                },
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetails.routeName, arguments: data.id);
            },
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: data.id!,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: data.imageURl!,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
