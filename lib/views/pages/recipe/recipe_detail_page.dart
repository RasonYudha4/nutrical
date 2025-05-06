import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrical/config/size_config.dart';

import '../../../blocs/recipe/recipe_bloc.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context) {
    context.read<RecipeBloc>().add(LoadRecipeById(recipeId));
    final double contentHeight = SizeConfig.height(70);
    final double textGap1 = SizeConfig.height(3);
    return Scaffold(
      backgroundColor: Color(0xFFD3E671),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Recipe Detail",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            SizedBox(height: 50),
            BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RecipeLoaded) {
                  final recipe = state.recipe;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: contentHeight,
                        padding: const EdgeInsets.only(
                          right: 30,
                          left: 30,
                          top: 10,
                          bottom: 30,
                        ),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8ED8C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: textGap1),
                              Text(recipe.desc),
                              SizedBox(height: textGap1),
                              Text(
                                "Ingredients :",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(recipe.ingredients.join(', ')),
                              SizedBox(height: textGap1),
                              Text(
                                "Step by step :",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    recipe.steps.asMap().entries.map((entry) {
                                      final index = entry.key + 1;
                                      final step = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Text("• Step $index: $step"),
                                      );
                                    }).toList(),
                              ),

                              SizedBox(height: textGap1),
                              Text(
                                "Nutritions :",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Serving : ${recipe.nutritions['serving']}"),
                              Text(
                                "Proteins : ${recipe.nutritions['proteins']}g",
                              ),
                              Text("Fats : ${recipe.nutritions['fat']}g"),
                              Text(
                                "Calories : ${recipe.nutritions['calories']} Cal",
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 0,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF89AC46),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            recipe.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('Failed to load recipe.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
