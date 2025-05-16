import 'package:flutter/material.dart';
import 'nutrition_circle.dart';

class NutritionCard extends StatelessWidget {
  final String nutrition;
  final Color progressColor;
  final int value;
  final int limit;
  final double width;

  const NutritionCard({
    super.key,
    required this.nutrition,
    required this.progressColor,
    required this.value,
    required this.limit,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final String category = nutrition.toLowerCase();
    final Color valueColor = getNutritionColor(value, limit, category);
    final bool isOver = value > limit;
    final int difference = (limit - value).abs();

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF89AC46),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(100, 0, 0, 0),
            spreadRadius: 1,
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              nutrition,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            NutritionCircle(
              radius: width * 0.4,
              lineWidth: 10,
              backgroundColor: const Color(0xFFD3E671),
              progressColor: progressColor,
              value: value,
              limit: limit,
              isPercentage: false,
              category: category,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$difference",
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOver ? "gr over" : "gr left",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
