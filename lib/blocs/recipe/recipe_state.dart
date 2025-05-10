part of 'recipe_bloc.dart';

sealed class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final Recipe recipe;

  const RecipeLoaded(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RecipeNamesLoaded extends RecipeState {
  final List<RecipeInfo> recipeList;

  const RecipeNamesLoaded(this.recipeList);
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}
