import 'meal.dart';

class MealPlan {
  final String id;
  final List<Meal?> days;

  MealPlan({required this.id, required this.days});

  factory MealPlan.fromMap(String id, Map<String, dynamic> data) {
    final rawList = data['days'] as List<dynamic>;

    final meals =
        rawList
            .where((e) => e != null)
            .map((e) => Meal.fromMap(Map<String, dynamic>.from(e)))
            .toList()
          ..sort((a, b) => a.day.compareTo(b.day));

    return MealPlan(id: id, days: meals);
  }

  Meal? _getMealForDay(int targetDay) {
    return days.firstWhere((m) => m?.day == targetDay, orElse: () => null);
  }

  String? getMealIdForDay(int targetDay, MealType type) {
    final meal = _getMealForDay(targetDay);
    if (meal == null) return null;

    switch (type) {
      case MealType.breakfast:
        return meal.breakfast;
      case MealType.lunch:
        return meal.lunch;
      case MealType.dinner:
        return meal.dinner;
    }
  }
}

enum MealType { breakfast, lunch, dinner }
