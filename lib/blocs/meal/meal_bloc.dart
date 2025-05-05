import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/meal.dart';
import '../../data/models/meal_plan.dart';
import '../../data/repositories/meal_repo.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepo _mealRepo = MealRepo();

  MealBloc() : super(MealInitial()) {
    on<LoadMealPlan>(_onLoadMealPlan);
  }

  Future<MealPlan?> _onLoadMealPlan(
    LoadMealPlan event,
    Emitter<MealState> emit,
  ) async {
    emit(MealLoading());
    try {
      final mealPlan = await _mealRepo.fetchMealPlan(event.userId);
      if (mealPlan == null) {
        emit(MealError('No meal plan found.'));
      } else {
        emit(MealPlanLoaded(mealPlan));
      }
    } catch (e) {
      emit(MealError('Failed to load meal plan: ${e.toString()}'));
    }
    return null;
  }
}
