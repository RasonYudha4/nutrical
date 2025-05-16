import 'package:flutter/material.dart';
import 'nutrition_circle.dart';

class CaloriesCard extends StatelessWidget {
  final int calories;
  final int caloriesLimit;

  const CaloriesCard({
    super.key,
    required this.calories,
    required this.caloriesLimit,
  });

  @override
  Widget build(BuildContext context) {
    final int difference = (caloriesLimit - calories).abs();
    final bool isOver = (caloriesLimit - calories) < 0;
    final Color valueColor = getNutritionColor(
      calories,
      caloriesLimit,
      "calories",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Calories",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "$difference",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: valueColor,
                            ),
                          ),
                          Text(
                            isOver ? " kcal over" : " kcal left",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "$calories ",
                            style: TextStyle(fontSize: 20, color: valueColor),
                          ),
                          Text(
                            "/ $caloriesLimit kcal",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  NutritionCircle(
                    radius: 65,
                    lineWidth: 15,
                    backgroundColor: const Color.fromARGB(255, 238, 252, 185),
                    progressColor: const Color.fromARGB(255, 35, 122, 18),
                    value: calories,
                    limit: caloriesLimit,
                    isPercentage: true,
                    category: "calories",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
