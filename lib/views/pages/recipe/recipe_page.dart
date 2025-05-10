import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/meal/meal_bloc.dart';
import '../../../blocs/recipe/recipe_bloc.dart';
import '../../../data/models/meal_plan.dart';
import '../../widgets/recipe/meal_day_section.dart';
import '../../widgets/recipe/meal_planner_card.dart';

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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final bloc = MealBloc();
              bloc.add(LoadMealPlan(user.id));
              return bloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final bloc = RecipeBloc();
              bloc.add(LoadRecipeNames());
              return bloc;
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    if (state is RecipeNamesLoaded) {
                      state.recipeList.forEach((recipe) {
                        print(
                          'Recipe UID: ${recipe.uid}, Name: ${recipe.name}',
                        );
                      });
                      return MealPlannerCard(
                        isEnabled: true,
                        recipeInfo: state.recipeList,
                      );
                    } else {
                      return const MealPlannerCard(
                        isEnabled: false,
                        recipeInfo: [],
                      );
                    }
                  },
                ),
                const SizedBox(height: 55),
                BlocBuilder<MealBloc, MealState>(
                  builder: (context, state) {
                    if (state is MealLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MealError) {
                      return Center(child: Text('Error: //${state.message}'));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final meal in mealPlan.days)
          if (meal != null) MealDaySection(mealDay: meal),
      ],
    );
  }
}
