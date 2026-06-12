import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final Widget icon;
  final String temperature;
  final String time;

  const HourlyForecastCard({
    super.key,
    required this.icon,
    required this.temperature,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          elevation: 6,

          child: Container(
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                icon,
                const SizedBox(height: 8),
                Text(temperature),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
