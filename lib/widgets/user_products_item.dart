import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/products_provider.dart';
import 'package:shopping/screens/edit_product_screen.dart';
import 'package:shopping/screens/product_in_detail_screen.dart';

class UserProductItem extends StatelessWidget {
  final String? name;
  final String? imageURL;
  final String? id;

  const UserProductItem(
      {Key? key, required this.id, required this.imageURL, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetails.routeName, arguments: id);
      },
      child: ListTile(
        title: Text(name!),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            imageURL!,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text(
                          'Are you sure you want to delete this product? this action cannot be undone!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await Provider.of<Products>(context,
                                      listen: false)
                                  .removeProduct(id!);
                            } catch (error) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Couldn\'t delete!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                            navigator.pop();
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
