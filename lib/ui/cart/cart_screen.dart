import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../orders/order_manager.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Column(children: <Widget>[
        buildCartSummary(cart, context),
        const SizedBox(height: 10),
        Expanded(
          child: buildCartDetails(cart),
        )
      ]),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => CartItemCard(
              productId: entry.key,
              cardItem: entry.value,
            ),
          )
          .toList(),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(), //khoảng cách tổng và tiền
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context)
                      .primaryTextTheme
                      .headline6
                      ?.color, //màu chữ
                ),
              ),
              /* backgroundColor: Theme.of(context).primaryColor, */
              backgroundColor: Colors.pink,
            ),
            TextButton(
              onPressed: cart.totalAmount <= 0
                  ? null
                  : () {
                      context.read<OrdersManager>().addOrder(
                            cart.product,
                            cart.totalAmount,
                          );
                      cart.clear();
                    },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              child: const Text(
                'MUA NGAY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
