part of 'meal_bloc.dart';

sealed class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadMealPlan extends MealEvent {
  final String userId;

  const LoadMealPlan(this.userId);
}

class SaveMealPlan extends MealEvent {
  final String userId;
  final List<Meal> meals;

  const SaveMealPlan({required this.userId, required this.meals});

  @override
  List<Object> get props => [userId, meals];
}
