import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/orders.dart';
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: ColorPalettes.darker,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.brown),
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 184, 43, 43),
      ),
      drawer: const MyDrawer(),
      body: ListView.separated(
          itemBuilder: ((context, i) {
            return OrderItem(
              order: orderData.orders[i],
            );
          }),
          separatorBuilder: ((context, index) {
            return const SizedBox(
              height: 5,
            );
          }),
          itemCount: orderData.orders.length),
    );
  }
}
