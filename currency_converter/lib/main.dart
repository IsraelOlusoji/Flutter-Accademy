import 'package:currency_converter/currency_converter_cupertino_page.dart';
import 'package:currency_converter/currency_converter_material_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp());
}

// Types of Widget

//In terms of UI Components
// 1. StatelessWidget
// -> build() method is called only once, when the widget is created
//
// 2. StatefulWidget`
// -> build() method is called every time the state is changed

//In terms of Data Management
//3. InheritedWidget

//state: refers to the data that can be changed, how the widget looks like at a certain point of time
// Mutable state: can be changed
// Immutable state: cannot be changed

//key
//A key is a handle to an element.

//Scaffold:
//Material Design visual layout structure.
// BuildContext: use to tell the framework where the widget is located in the widget tree.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CurrencyConverterMaterialPage());
  }
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(home: CurrencyConverterCupertinoPage());
  }
}
