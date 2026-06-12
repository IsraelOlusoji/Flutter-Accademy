import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late int abc;

  @override
  //initstate is amethod which runs once after the constractorof the app state is called.
  //since it runs at the start of the app we can initialize data amd properties with some values.
  void initState() {
    super.initState();

    abc = 10;
  }

  @override
  // didchangendependencies is a method which is called immediately after initstate is called.
  //and if there is any dependency of the widget it is called immediately after the dependency is changed.
  //this method is used to update the widget data once after the initstate is called.
  void didChangeDependencies() {
    super.didChangeDependencies();
    //this widget is rarely used but it is called when the widget attached to the state is changed.
  }

  @override
  //didUpdateWidget is a method which is called when the widget attached to the state is replaced by a another widget.
  void didUpdateWidget(covariant MyStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //this widget is rarely used.
  }

  @override
  //used to remove all the connections that the app has with the widget before it is removed from the widget tree.
  //it is used to clean up the resources used by the widget.
  //it is a very important method most people forgot to use this method.
  void dispose() {
    super.dispose();
  }

  @override
  //build widget is a method which is called every time the widget is built.
  //when initstate is called the build method is called once.
  //when setstate is called the build method is called again.
  //when the widget is disposed the build method is called again.
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(abc.toString())));
  }
}
