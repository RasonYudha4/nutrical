import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/recipe/recipe_bloc.dart';
import '../../../../views/pages/recipe/recipe_detail_page.dart';

class MealCard extends StatelessWidget {
  final String mealType;
  final String recipeId;
  final String ingredients;

  const MealCard({
    super.key,
    required this.mealType,
    required this.recipeId,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    if (recipeId != 'No meal planned') {
      return BlocProvider(
        create: (context) {
          final recipeBloc = RecipeBloc();
          recipeBloc.add(LoadRecipeById(recipeId));
          return recipeBloc;
        },
        child: Builder(
          builder: (innerContext) {
            return BlocBuilder<RecipeBloc, RecipeState>(
              builder: (builderContext, state) {
                String displayName = recipeId;
                String displayIngredients = ingredients;

                if (state is RecipeLoaded) {
                  displayName = state.recipe.name;

                  if (state.recipe.ingredients.isNotEmpty) {
                    final ingredientsList = state.recipe.ingredients;
                    if (ingredientsList.length > 3) {
                      displayIngredients =
                          "${ingredientsList[0]}, ${ingredientsList[1]}, ${ingredientsList[2]}...";
                    } else {
                      displayIngredients = ingredientsList.join(", ");
                    }
                  }
                }

                return _buildMealCardContent(
                  context: builderContext,
                  innerContext: innerContext,
                  mealType: mealType,
                  recipeId: recipeId,
                  displayName: displayName,
                  ingredients: displayIngredients,
                  isLoading: state is RecipeLoading,
                );
              },
            );
          },
        ),
      );
    } else {
      return _buildMealCardContent(
        context: context,
        innerContext: null,
        mealType: mealType,
        recipeId: recipeId,
        displayName: recipeId,
        ingredients: ingredients,
        isLoading: false,
      );
    }
  }

  Widget _buildMealCardContent({
    required BuildContext context,
    BuildContext? innerContext,
    required String mealType,
    required String recipeId,
    required String displayName,
    required String ingredients,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (recipeId != 'No meal planned' && innerContext != null) {
          final recipeBloc = innerContext.read<RecipeBloc>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return BlocProvider.value(
                  value: recipeBloc,
                  child: RecipeDetailPage(recipeId: recipeId),
                );
              },
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF89AC46),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 0.8),
                  isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 100,
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFF9DBC5E),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  const SizedBox(height: 0.8),
                  Text(
                    "Ingredients: $ingredients",
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            if (recipeId != 'No meal planned')
              const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
