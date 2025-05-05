import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrical/data/models/meal_plan.dart';

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
}
