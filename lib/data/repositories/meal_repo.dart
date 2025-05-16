import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/meal.dart';
import '../models/meal_plan.dart';

class MealRepo {
  Future<MealPlan?> fetchMealPlan(String userId) async {
    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("MealPlan")
        .doc(userId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    return MealPlan.fromMap(userId, data);
  }

  Future<void> saveMealPlan(String userId, List<Meal> meals) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("MealPlan")
          .doc(userId);

      final Map<String, dynamic> mealsData = {
        'days':
            meals
                .map(
                  (meal) => {
                    'day': meal.day,
                    'breakfast': meal.breakfast,
                    'lunch': meal.lunch,
                    'dinner': meal.dinner,
                  },
                )
                .toList(),
      };

      await docRef.set(mealsData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save meal plan: ${e.toString()}');
    }
  }
}
