import 'package:flutter/material.dart';
import 'package:shop_app/global_variables.dart';
import 'package:shop_app/home_page.dart';
import 'package:shop_app/product_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        fontFamily: 'Lato',

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(254, 206, 1, 1),
          primary: Color.fromRGBO(254, 206, 1, 1),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          prefixIconColor: Color.fromRGBO(199, 199, 199, 1),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          bodySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      home:
          // const HomePage(),
          ProductDetailsPage(product: products[0]),
    );
  }
}
