import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, Object> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Product Details')),
      body: Column(
        children: [
          Center(
            child: Text(
              product['title'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          //Spacer() push the content above it to the top
          // and the content below it to the bottom
          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(product['imageUrl'] as String),
          ),
          const Spacer(flex: 2),

          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(216, 240, 253, 1),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${product['price']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: (product['sizes'] as List<int>).length,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (BuildContext context, int index) {
                      final size = (product['sizes'] as List<int>)[index];

                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Chip(label: Text(size.toString())),
                      );
                    },
                  ),
                ),

                // const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      // foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
