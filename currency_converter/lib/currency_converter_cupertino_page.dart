import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

class CurrencyConverterCupertinoPage extends StatefulWidget {
  const CurrencyConverterCupertinoPage({super.key});

  @override
  State<CurrencyConverterCupertinoPage> createState() =>
      _CurrencyConverterCupertinoPageState();
}

class _CurrencyConverterCupertinoPageState
    extends State<CurrencyConverterCupertinoPage> {
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          "Currency Converter",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: CupertinoColors.opaqueSeparator,
          ),
        ),

        backgroundColor: CupertinoColors.systemPink,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result != 0
                    ? "Ngn${result.toStringAsFixed(2)}"
                    : result.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemBrown,
                ),
              ),

              CupertinoTextField(
                controller: textEditingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: CupertinoColors.black),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),

                placeholder: "Enter amount in USD",
                prefix: const Icon(CupertinoIcons.money_dollar),
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              CupertinoButton(
                color: CupertinoColors.systemGrey3,
                onPressed: () {
                  setState(() {
                    result = double.parse(textEditingController.text) * 1380;
                  });
                },

                child: const Text('Convert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
