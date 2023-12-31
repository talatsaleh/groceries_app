import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goreceries_app/data/categories.dart';
import 'package:goreceries_app/module/grocery_module.dart';
import 'package:goreceries_app/widgets/groceryItem.dart';
import 'package:http/http.dart' as http;
import 'add_new_item_screen.dart';
import 'package:goreceries_app/module/category_module.dart' as cat;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var init = false;
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String _error = 'There is no Grocery to see..';

  void _removeItem(GroceryItem item, int index) async {
    setState(() {
      _groceryItems.remove(_groceryItems[index]);
    });
    final url = Uri.https('groceries-app-c60ac-default-rtdb.firebaseio.com',
        'shoping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('there is error.. try again..')));
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  Future<void> _getItems() async {
    if (init) {
      setState(() {
        _isLoading = true;
      });
    }
    init = true;
    final List<GroceryItem> items = [];
    final url = Uri.https(
        'groceries-app-c60ac-default-rtdb.firebaseio.com', 'shoping-list.json');
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        setState(() {
          _error = 'There is no Grocery to see..';
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = jsonDecode(response.body);
      for (final item in listData.entries) {
        final cat.Category catItem = categories.values
            .firstWhere((cat) => cat.name == item.value['category']);
        items.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: catItem,
          ),
        );
      }
      setState(() {
        _isLoading = false;
        _groceryItems = items;
      });
    } catch (error) {
      _error = 'There is problem right now, please try again.';
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getItems();
    super.initState();
  }

  void _addNewItem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (ctx) {
      return const AddNewItemScreen();
    }));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  Future<bool?> _dismissible(_) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
    final appBar = AppBar(
      title: const Text('Your Groceries'),
      actions: [
        IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
      ],
    );
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: _getItems,
        child: _isLoading
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  child: const CircularProgressIndicator(),
                ),
              )
            : Container(
                alignment: Alignment.center,
                height: height,
                child: _groceryItems.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Text(_error),
                      )
                    : ListView.builder(
                        itemCount: _groceryItems.length,
                        itemBuilder: (ctx, index) {
                          return Dismissible(
                            confirmDismiss: _dismissible,
                            background: Container(
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                              child: const Icon(Icons.delete),
                            ),
                            onDismissed: (_) {
                              _removeItem(_groceryItems[index], index);
                            },
                            key: ValueKey(index),
                            child: GroceryItemWidget(
                                grocery: _groceryItems[index]),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
