import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fruitshop/ui/products/products_manager.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import 'edit_product_screen.dart';

class UserProductListTile extends StatelessWidget {
  final Product product;

  const UserProductListTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            buildEditButton(context),
            buildDeleteButtoon(context),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteButtoon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        context.read<ProductsManager>().deleteProduct(product.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Sản phẩm đã được xóa',
                textAlign: TextAlign.center,
              ),
            ),
          );
      },
      /* color: Theme.of(context).errorColor, */
      color: Colors.red,
    );
  }

  Widget buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: product.id,
        );
      },
      /* color: Theme.of(context).primaryColor, */
      color: Colors.blue,
    );
  }
}
