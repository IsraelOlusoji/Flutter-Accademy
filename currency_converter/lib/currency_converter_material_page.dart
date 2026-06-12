import 'package:flutter/material.dart';

//1. create a variable that stores the converted currency value
//2. create a function that multiplies the value given by the textfield with the exchange rate
//3. store the result of the multiplication in the variable created
//4. Display the result in the text widget

// to create a stateful widget, we need to create two classes
// 1. stateful widget: which doesn't have any data.
// 2. state: which has the data and methods.

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});
  @override
  State createState() => _CurrencyConverterMaterialPageState();
}

// naming convention
// for stateful widget, the state class is prefixed with an underscore to
// indicate that it is a private class
// _CurrencyConverterMaterialPageState

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0;
  final textEditingController = TextEditingController();
  void convert() {
    setState(() {
      result = double.parse(textEditingController.text) * 1380;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  //textEditingController
  // A controller for an editable text field.
  // It can be used to read, modify, or listen to the text field in the entire app
  //(including when the keyboard is open or closed).
  //
  // To prevent memory leakage, we need to dispose of the controller when the widget
  // is disposed of.

 

  //build method is called only once when the widget is created
  @override
  Widget build(BuildContext context) {
    // return const Scaffold();
    // Border for the text field (rounded corners, no visible border)
    const border = OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(60)),
    );

    return Scaffold(
      //Scaffold
      // Material design visual layout structure.
      // body: Widget
      // backgroundColor: Colors.amber
      //  Color - A representation of colors in the ARGB (Alpha, Red, Green, Blue) format.
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,

        //Actions: button to the right of the title

        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.monetization_on),
        //     color: Colors.white70,
        //   ),
        // ],

        // Leading: button to the left of the title
        //
        // leading: IconButton(
        //   onPressed: () {
        //     print('button pressed');
        //   },
        //   icon: const Icon(Icons.monetization_on),
        //   color: Colors.white70,
        // ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result != 0
                    ? "NGN ${result.toStringAsFixed(2)}"
                    : result.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              //padding: padding is used to give space around the widget(inside)
              //margin: margin is used to give space around the widget(outside)
              //container: allows to set bunch of properties to a widget
              TextField(
                controller: textEditingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.black54),
                decoration: const InputDecoration(
                  hintText: "Enter amount in Dollar",
                  hintStyle: TextStyle(color: Colors.black),

                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  prefixIconColor: Colors.black54,

                  filled: true,
                  fillColor: Colors.white,

                  focusedBorder: border,
                  enabledBorder: border,
                ),
              ),

              //button
              // in material design, button can be classified into:
              // 1. ElevatedButton: gives a solid background color to the button.
              //    like a 3d effect. originally called a raised button.
              // 2. OutlinedButton: gives a border to the button. flat style.
              // 3. TextButton: gives no background color and no border to the button.
              //    Like a simple flat text(button). originally called flat button.
              //

              //Space between the text field and the button
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    result = double.parse(textEditingController.text) * 1380;
                  });
                },

                // const
                // ButtonStyle(
                // backgroundColor: WidgetStatePropertyAll(Colors.black),
                // foregroundColor: WidgetStatePropertyAll(Colors.white),
                // minimumSize: WidgetStatePropertyAll(
                //   Size(double.infinity, 50),
                // ),
                // shape: WidgetStatePropertyAll(
                //   RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                // ),
                // ),

                // ElevatedButton.styleFrom:
                // This is the default way to style the button.
                // It is a factory constructor that creates an instance of
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                child: const Text('Convert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CurrencyConverterMaterialPagee extends StatelessWidget {
//   const CurrencyConverterMaterialPagee({super.key});

//   @override
//   Widget build(BuildContext context) {}
// }
