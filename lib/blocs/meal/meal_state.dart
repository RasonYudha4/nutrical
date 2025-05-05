part of 'meal_bloc.dart';

sealed class MealState extends Equatable {
  const MealState();

  @override
  List<Object> get props => [];
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealPlanLoading extends MealState {}

class MealLoaded extends MealState {
  final Meal meal;

  const MealLoaded(this.meal);
}

class MealPlanLoaded extends MealState {
  final MealPlan mealPlan;

  const MealPlanLoaded(this.mealPlan);
}

class MealError extends MealState {
  final String message;

  const MealError(this.message);
}
