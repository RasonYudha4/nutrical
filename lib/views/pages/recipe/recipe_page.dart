import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    print('Current user ID: ${user.id}');
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            final bloc = MealBloc();
            bloc.add(LoadMealPlan(user.id));
            return bloc;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
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
      ),
    );
  }

  Widget _buildMealPlanContent(BuildContext context, MealPlan mealPlan) {
    // Convert numeric days to day names
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
                // Breakfast
                GestureDetector(
                  onTap: () {
                    final recipeId = mealPlan.getMealIdForDay(
                      meal.day,
                      MealType.breakfast,
                    );
                    if (recipeId != null && recipeId.isNotEmpty) {
                      context.read<RecipeBloc>().add(LoadRecipeById(recipeId));
                      _showRecipeDetail(context);
                    }
                  },
                  child: _buildMealCard(
                    mealType: 'Breakfast',
                    mealName:
                        meal.breakfast.isNotEmpty
                            ? meal.breakfast
                            : 'No meal planned',
                    ingredients: 'Tap to see details',
                  ),
                ),
                const SizedBox(height: 12),
                // Lunch
                GestureDetector(
                  onTap: () {
                    final recipeId = mealPlan.getMealIdForDay(
                      meal.day,
                      MealType.lunch,
                    );
                    if (recipeId != null && recipeId.isNotEmpty) {
                      context.read<RecipeBloc>().add(LoadRecipeById(recipeId));
                      _showRecipeDetail(context);
                    }
                  },
                  child: _buildMealCard(
                    mealType: 'Lunch',
                    mealName:
                        meal.lunch.isNotEmpty ? meal.lunch : 'No meal planned',
                    ingredients: 'Tap to see details',
                  ),
                ),
                const SizedBox(height: 12),
                // Dinner
                GestureDetector(
                  onTap: () {
                    final recipeId = mealPlan.getMealIdForDay(
                      meal.day,
                      MealType.dinner,
                    );
                    if (recipeId != null && recipeId.isNotEmpty) {
                      context.read<RecipeBloc>().add(LoadRecipeById(recipeId));
                      _showRecipeDetail(context);
                    }
                  },
                  child: _buildMealCard(
                    mealType: 'Dinner',
                    mealName:
                        meal.dinner.isNotEmpty
                            ? meal.dinner
                            : 'No meal planned',
                    ingredients: 'Tap to see details',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
      ],
    );
  }

  void _showRecipeDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecipeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is RecipeLoaded) {
                  final recipe = state.recipe;
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.desc,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final ingredient in recipe.ingredients)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• $ingredient'),
                          ),
                        const SizedBox(height: 16),
                        const Text(
                          'Steps:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (int i = 0; i < recipe.steps.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('${i + 1}. ${recipe.steps[i]}'),
                          ),
                        if (recipe.nutritions.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Nutrition Facts:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          for (var entry in recipe.nutritions.entries)
                            Text('${entry.key}: ${entry.value}'),
                        ],
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No recipe data available'));
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealPlanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const MealPlannerPage();
            },
          ),
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

  Widget _buildMealCard({
    required String mealType,
    required String mealName,
    required String ingredients,
  }) {
    return Container(
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
                Text(
                  mealName,
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
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}
