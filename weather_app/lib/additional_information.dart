import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const AdditionalInformationItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
