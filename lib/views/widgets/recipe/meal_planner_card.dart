import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../../../views/pages/recipe/meal_planner_page.dart';
import '../../../blocs/meal/meal_bloc.dart';
import '../../../data/models/meal.dart';
import '../../../data/models/recipe_info.dart';

class MealPlannerCard extends StatefulWidget {
  final String userId;
  final bool isEnabled;
  final List<RecipeInfo> recipeInfo;

  const MealPlannerCard({
    super.key,
    required this.userId,
    required this.isEnabled,
    required this.recipeInfo,
  });

  @override
  MealPlannerCardState createState() => MealPlannerCardState();
}

class MealPlannerCardState extends State<MealPlannerCard> {
  late TextEditingController _meatRecipeController;

  @override
  void initState() {
    super.initState();
    _meatRecipeController = TextEditingController();
  }

  @override
  void dispose() {
    _meatRecipeController.dispose();
    super.dispose();
  }

  void _generateMealPlan() async {
    final inputText = _meatRecipeController.text.trim();
    if (inputText.isEmpty) return;

    final recipeList = widget.recipeInfo
        .map((r) => '- ${r.name} (uid: ${r.uid})')
        .join('\n');

    final promptText = '''
      Here's a list of existing meals:
      $recipeList

      Based on the user's request: "$inputText", recommend meals for the week (breakfast, lunch, dinner for each day from Monday to Sunday).

      Use ONLY the UIDs from the list above when suggesting meals.

      Respond strictly in this format:

      {
        "days": [
          { "day": 1, "breakfast": "recipe_uid", "lunch": "recipe_uid", "dinner": "recipe_uid" },
          ...
          { "day": 7, "breakfast": "recipe_uid", "lunch": "recipe_uid", "dinner": "recipe_uid" }
        ]
      }
    ''';

    final parts = [Part.text(promptText)];

    try {
      _showLoadingDialog();

      final gemini = Gemini.instance;
      final response = await gemini.prompt(parts: parts);

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      if (response?.output != null) {
        final String jsonStr = _extractJsonFromResponse(response!.output ?? "");

        try {
          final dynamic parsedJson = jsonDecode(jsonStr);

          if (parsedJson != null && parsedJson['days'] != null) {
            final List<dynamic> daysData = parsedJson['days'];
            final List<Meal> meals =
                daysData.map((dayData) => Meal.fromMap(dayData)).toList();

            context.read<MealBloc>().add(
              SaveMealPlan(userId: widget.userId, meals: meals),
            );
          } else {
            _showErrorMessage('Invalid response format from AI service');
          }
        } catch (e) {
          _showErrorMessage('Failed to parse AI response: ${e.toString()}');
        }
      } else {
        _showErrorMessage('Failed to get response from AI service');
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorMessage('Error generating meal plan: ${e.toString()}');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Color(0xFF89AC46),
          content: Container(
            height: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
            child: Row(
              children: const [
                CircularProgressIndicator(color: Color(0xFFD3E671)),
                SizedBox(width: 20),
                Text(
                  "Generating meal plan...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD3E671),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _extractJsonFromResponse(String response) {
    final startIndex = response.indexOf('{');
    final endIndex = response.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return response.substring(startIndex, endIndex + 1);
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFF9BBB45), Color(0xFF7A9530)],
                        center: Alignment(-0.3, -0.3),
                        radius: 0.9,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Planner',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _meatRecipeController,
                    decoration: InputDecoration(
                      hintText: 'What you want to eat?',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF89AC46),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:
                      widget.isEnabled
                          ? () {
                            _generateMealPlan();
                          }
                          : null,
                  child: Icon(
                    Icons.send,
                    color: widget.isEnabled ? Colors.black : Colors.grey,
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
