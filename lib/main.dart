import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/orders.dart';
import 'package:shopping/providers/products_provider.dart';
import 'package:shopping/screens/auth_screen.dart';
import 'package:shopping/screens/cart_screen.dart';
import 'package:shopping/screens/edit_product_screen.dart';
import 'package:shopping/screens/favorite_products.dart';
import 'package:shopping/screens/orders_screen.dart';
import 'package:shopping/screens/product_in_detail_screen.dart';
import 'package:shopping/screens/user_products.dart';

import 'screens/products_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return Auth();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, previousProducts) {
              return Products(auth.token!, auth.userId,
                  previousProducts == null ? [] : previousProducts.items);
            },
            create: (context) {
              return Products('', '', []);
            },
          ),
          ChangeNotifierProvider(
            create: (context) {
              return Cart();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
              update: (context, auth, previousOrder) {
            return Order(
              auth.token!,
              previousOrder == null ? [] : previousOrder.orders,
            );
          }, create: (context) {
            return Order('', []);
          })
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Lato',
                primarySwatch: Colors.brown,
              ),
              home: auth.isAuth ? ProductsListScreen() : const AuthScreen(),
              routes: {
                ProductDetails.routeName: (context) => const ProductDetails(),
                FavoriteProductsList.routeName: (context) =>
                    const FavoriteProductsList(),
                CartScreen.routeName: (context) => const CartScreen(),
                OrdersScreen.routeName: (context) => const OrdersScreen(),
                UserProductsScreen.routeName: (context) =>
                    const UserProductsScreen(),
                EditProductScreen.routeName: (context) =>
                    const EditProductScreen(),
              },
            );
          },
        ));
  }
}
