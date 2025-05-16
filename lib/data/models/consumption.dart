class Consumption {
  final String id;
  final int calories;
  final int carbs;
  final int proteins;
  final int fats;
  final int servingSize;
  final String mealType;
  final String foodName;

  Consumption({
    required this.id,
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
    required this.servingSize,
    required this.mealType,
    required this.foodName,
  });

  factory Consumption.fromMap(String id, Map<String, dynamic> map) {
    return Consumption(
      id: id,
      calories: (map['calories'] ?? 0) as int,
      carbs: (map['carbs'] ?? 0) as int,
      proteins: (map['proteins'] ?? 0) as int,
      fats: (map['fats'] ?? 0) as int,
      servingSize: (map['serving_size'] ?? 1) as int,
      mealType: map['meal_type'] ?? '',
      foodName: map['food_name'] ?? '',
    );
  }

  factory Consumption.fromGeminiResponse({
    required Map<String, dynamic> map,
    required int servingSize,
    required String mealType,
  }) {
    return Consumption(
      id: '',
      calories: (map['calories'] ?? 0) as int,
      carbs: (map['carbohydrates'] ?? 0) as int,
      proteins: (map['proteins'] ?? 0) as int,
      fats: (map['fats'] ?? 0) as int,
      servingSize: servingSize,
      mealType: mealType,
      foodName: map['food_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'carbs': carbs,
      'proteins': proteins,
      'fats': fats,
      'serving_size': servingSize,
      'meal_type': mealType,
      'food_name': foodName,
    };
  }

  Map<String, num> calculateTotals() {
    return {
      'carbs': carbs * servingSize,
      'proteins': proteins * servingSize,
      'fats': fats * servingSize,
      'calories': calories * servingSize,
    };
  }
}
