import 'package:flutter/material.dart';
import 'package:goreceries_app/data/dummy_items.dart';
import 'package:goreceries_app/module/grocery_module.dart';
import 'package:goreceries_app/widgets/groceryItem.dart';

import 'add_new_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _addNewItem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
      return const AddNewItemScreen();
    }));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem!);
    });
  }

  Future<bool?> _dismissible(_) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snack = await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: const Text('deleted Undo?'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        ))
        .closed;
    if (snack == SnackBarClosedReason.action) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
        ],
      ),
      body: _groceryItems.isEmpty
          ? const Center(
              child: Text('There is no Grocery to see..'),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  confirmDismiss: _dismissible,
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: const Icon(Icons.delete),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      _groceryItems.remove(_groceryItems[index]);
                    });
                  },
                  key: ValueKey(index),
                  child: GroceryItemWidget(grocery: _groceryItems[index]),
                );
              },
            ),
    );
  }
}
