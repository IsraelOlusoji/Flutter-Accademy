import 'package:flutter/material.dart';
import 'package:understanding_widget/my_stateful_widget.dart';
import 'package:understanding_widget/my_stateless_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //widget is every class made and can call in the build method(function) without any errors.
  //A stateless widget is a widget that doesn't have any state. It is a widget that can be used to display
  //information that is not changing.once created it can't be changed, cannot be redone after any user interaction
  //A stateful widget is a widget that has state. It is a widget that can be used to display
  //information that is changing.once created it can be changed, can be redone after any user interaction

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiget Life Cycle',
      theme: ThemeData.light(),
      home: MyStatefulWidget(),
    );
  }
}
