import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final Color backgroundColor;
  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration and color cannot be in same place (same container root)
      //it can be either inside decoration or outside decoration
      //if inside decoration, then color will not work
      //if outside decoration, then border-radius will not work
      //in this case, we can use DecoratedBox
      //but it is not necessary here because we can use color property of Container
      //color: Color.fromARGB(216, 240, 253, 1),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            softWrap: true,
          ),
          SizedBox(height: 5),
          Text('\$$price', style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: 10),
          Center(child: Image.asset(imageUrl, height: 170)),
        ],
      ),
    );
  }
}
