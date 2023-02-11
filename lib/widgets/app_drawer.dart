import 'package:flutter/material.dart';
import 'package:shopping/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            title: const Text(
              "Hello There!",
              style: TextStyle(color: ColorPalettes.darker),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(0, 176, 170, 170),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
              color: ColorPalettes.dark,
            ),
            title: const Text(
              "Shop",
              style: TextStyle(color: ColorPalettes.darker),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.payment,
              color: ColorPalettes.dark,
            ),
            title: const Text(
              "Orders",
              style: TextStyle(color: ColorPalettes.darker),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/orders_screen');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
              color: ColorPalettes.dark,
            ),
            title: const Text(
              "Manage Products",
              style: TextStyle(color: ColorPalettes.darker),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/user_products_screen');
            },
          ),
        ],
      ),
    );
  }
}
