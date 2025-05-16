import 'package:equatable/equatable.dart';

import 'consumption.dart'; // adjust the path if needed

class NutritionSummary extends Equatable {
  final int carbs;
  final int proteins;
  final int fats;
  final int calories;

  const NutritionSummary({
    required this.carbs,
    required this.proteins,
    required this.fats,
    required this.calories,
  });

  factory NutritionSummary.fromConsumptions(List<Consumption> consumptions) {
    int totalCarbs = 0;
    int totalProteins = 0;
    int totalFats = 0;
    int totalCalories = 0;

    for (var consumption in consumptions) {
      totalCarbs += (consumption.carbs * consumption.servingSize).toInt();
      totalProteins += (consumption.proteins * consumption.servingSize).toInt();
      totalFats += (consumption.fats * consumption.servingSize).toInt();
      totalCalories += (consumption.calories * consumption.servingSize).toInt();
    }

    return NutritionSummary(
      carbs: totalCarbs,
      proteins: totalProteins,
      fats: totalFats,
      calories: totalCalories,
    );
  }

  factory NutritionSummary.empty() {
    return const NutritionSummary(carbs: 0, proteins: 0, fats: 0, calories: 0);
  }

  @override
  List<Object> get props => [carbs, proteins, fats, calories];
}
