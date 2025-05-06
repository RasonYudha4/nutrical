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
