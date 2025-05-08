import 'package:flutter/material.dart';

class MealTypeCard extends StatelessWidget {
  final String mealType;
  final Color primaryColor;
  final VoidCallback? onTap;

  const MealTypeCard({
    super.key,
    required this.mealType,
    required this.primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealType,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward_ios_sharp),
          ],
        ),
      ),
    );
  }
}
