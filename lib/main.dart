import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const GroceriesApp());
}

class GroceriesApp extends StatelessWidget {
  const GroceriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      title: 'Groceries Store',
      home: const HomeScreen(),
    );
  }
}
