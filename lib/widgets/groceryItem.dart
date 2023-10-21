import 'package:flutter/material.dart';
import 'package:goreceries_app/data/dummy_items.dart';
import 'package:goreceries_app/module/grocery_module.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({super.key, required this.grocery});

  final GroceryItem grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(grocery.name),
      leading: Container(
        width: 30,
        height: 30,
        color: grocery.category.color,
      ),
      trailing: Text(
        grocery.quantity.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
