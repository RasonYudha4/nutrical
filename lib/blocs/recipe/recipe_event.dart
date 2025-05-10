part of 'recipe_bloc.dart';

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipeById extends RecipeEvent {
  final String id;

  const LoadRecipeById(this.id);
}

class LoadRecipeNames extends RecipeEvent {}
