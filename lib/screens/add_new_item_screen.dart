import 'package:flutter/material.dart';
import 'package:goreceries_app/data/categories.dart';
import 'package:goreceries_app/module/category_module.dart';
import 'package:goreceries_app/module/grocery_module.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final TextEditingController _quantity = TextEditingController(text: '1');
  final _nameFormKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool _lastState = false;
  late final String _name;
  late final Category _category;

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  void _saveForm() {
    _formKey.currentState!.save();
    final addedItem = GroceryItem(
        id: DateTime.now().toString(),
        name: _name,
        quantity: int.parse(_quantity.text),
        category: _category);
    Navigator.of(context).pop(addedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          onChanged: () {
            print('changed');
            _isValid = _formKey.currentState!.validate();
            if (_isValid != _lastState) {
              setState(() {});
            }
            _lastState = _isValid;
            print(_isValid);
          },
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'name is empty. try to write it.';
                  }
                },
                key: _nameFormKey,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 8,
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'chose category please..';
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          'Category',
                        ),
                      ),
                      onSaved: (value) {
                        _category = value!;
                        print(_category.name);
                      },
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(category.value.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (Category? value) {},
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      onEditingComplete: () {
                        if (int.tryParse(_quantity.text) == null ||
                            int.tryParse(_quantity.text)! < 1) {
                          _quantity.text = '1';
                        }
                      },
                      controller: _quantity,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        _quantity.text =
                            (int.tryParse(_quantity.text)! + 1).toString();
                      },
                      icon: Icon(
                        Icons.add,
                        size: 28,
                        color: Colors.green[200],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        if (int.tryParse(_quantity.text)! > 1) {
                          final temp = int.tryParse(_quantity.text)! - 1;
                          _quantity.text = temp.toString();
                        }
                      },
                      icon: Icon(
                        Icons.remove,
                        size: 28,
                        color: Colors.red[200],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text(
                      'Reset',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isValid
                        ? () {
                            _saveForm();
                          }
                        : null,
                    child: const Text('Add item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
