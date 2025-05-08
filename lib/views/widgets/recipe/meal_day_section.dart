import 'package:flutter/material.dart';

import '../../../data/models/meal.dart';
import 'meal_card.dart';

class MealDaySection extends StatelessWidget {
  final Meal mealDay;

  const MealDaySection({super.key, required this.mealDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getDayName(mealDay.day),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        MealCard(
          mealType: 'Breakfast',
          recipeId:
              mealDay.breakfast.isNotEmpty
                  ? mealDay.breakfast
                  : 'No meal planned',
          ingredients: 'Tap to see details',
        ),
        const SizedBox(height: 12),
        MealCard(
          mealType: 'Lunch',
          recipeId:
              mealDay.lunch.isNotEmpty ? mealDay.lunch : 'No meal planned',
          ingredients: 'Tap to see details',
        ),
        const SizedBox(height: 12),
        MealCard(
          mealType: 'Dinner',
          recipeId:
              mealDay.dinner.isNotEmpty ? mealDay.dinner : 'No meal planned',
          ingredients: 'Tap to see details',
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Day $day';
    }
  }
}
