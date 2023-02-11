import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/providers/orders.dart' as ord;
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItems? order;
  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order!.amount!.toStringAsFixed(2)}"),
            subtitle: Text(widget.order!.dateTime.toString().substring(0, 16)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
              ),
            ),
          ),
          if (_expanded)
            SizedBox(
              height: min(widget.order!.products!.length * 20.0 + 100, 100),
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return Card(
                    elevation: 0,
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
                            imageUrl: widget.order!.products![index].imageURl!,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.order!.products![index].name!,
                        style: const TextStyle(
                            color: ColorPalettes.darker,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${widget.order!.products![index].quantity.toString()}x \$${widget.order!.products![index].price.toString()}",
                              style:
                                  const TextStyle(color: ColorPalettes.dark)),
                        ],
                      ),
                    ),
                  );
                }),
                itemCount: widget.order!.products!.length,
              ),
            ),
        ],
      ),
    );
  }
}
