import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrical/views/pages/recipe/recipe_detail_page.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/meal/meal_bloc.dart';
import '../../../blocs/recipe/recipe_bloc.dart';
import '../../../data/models/meal_plan.dart';
import 'meal_planner_page.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: BlocProvider(
        create: (context) {
          final bloc = MealBloc();
          bloc.add(LoadMealPlan(user.id));
          return bloc;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMealPlanner(),
                const SizedBox(height: 55),
                BlocBuilder<MealBloc, MealState>(
                  builder: (context, state) {
                    if (state is MealLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MealError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is MealPlanLoaded) {
                      return _buildMealPlanContent(context, state.mealPlan);
                    } else {
                      return const Center(
                        child: Text('No meal plan available'),
                      );
                    }
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlanContent(BuildContext context, MealPlan mealPlan) {
    String getDayName(int day) {
      switch (day) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3:
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        case 7:
          return 'Sunday';
        default:
          return 'Day $day';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final meal in mealPlan.days)
          if (meal != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getDayName(meal.day),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  context: context,
                  mealType: 'Breakfast',
                  recipeId:
                      meal.breakfast.isNotEmpty
                          ? meal.breakfast
                          : 'No meal planned',
                  ingredients: 'Tap to see details',
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  context: context,
                  mealType: 'Lunch',
                  recipeId:
                      meal.lunch.isNotEmpty ? meal.lunch : 'No meal planned',
                  ingredients: 'Tap to see details',
                ),
                const SizedBox(height: 12),
                _buildMealCard(
                  context: context,
                  mealType: 'Dinner',
                  recipeId:
                      meal.dinner.isNotEmpty ? meal.dinner : 'No meal planned',
                  ingredients: 'Tap to see details',
                ),
                const SizedBox(height: 30),
              ],
            ),
      ],
    );
  }

  Widget _buildMealCard({
    required BuildContext context,
    required String mealType,
    required String recipeId,
    required String ingredients,
  }) {
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

  Widget _buildMealPlanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MealPlannerPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E671),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(3, 4),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF9BBB45), // Lighter center
                          Color(0xFF7A9530), // Darker edge
                        ],
                        center: Alignment(-0.3, -0.3),
                        radius: 0.9,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Planner',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Let me help you to analyze\nyour raw ingredients',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 35),
            const Divider(thickness: 2.2, color: Colors.black),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'What kind of food do you want to eat this week',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF89AC46),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
