import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/recipe.dart';
import '../../data/models/recipe_info.dart';
import '../../data/repositories/recipe_repo.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepo _recipeRepo = RecipeRepo();

  RecipeBloc() : super(RecipeInitial()) {
    on<LoadRecipeById>(_onLoadRecipeById);
    on<LoadRecipeNames>(_onLoadRecipeNames);
  }

  Future<Recipe?> _onLoadRecipeById(
    LoadRecipeById event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipe = await _recipeRepo.getRecipeById(event.id);
      emit(RecipeLoaded(recipe));
    } catch (e) {
      emit(RecipeError('Failed to load meal plans: ${e.toString()}'));
    }
    return null;
  }

  Future<void> _onLoadRecipeNames(
    LoadRecipeNames event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipeList = await _recipeRepo.getAllRecipeInfo();
      emit(RecipeNamesLoaded(recipeList));
    } catch (e) {
      emit(RecipeError('Failed to load recipe names: ${e.toString()}'));
    }
  }
}
