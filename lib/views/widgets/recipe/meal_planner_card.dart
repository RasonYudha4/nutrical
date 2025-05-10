import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../../../views/pages/recipe/meal_planner_page.dart';
import '../../../data/models/recipe_info.dart';

class MealPlannerCard extends StatefulWidget {
  final bool isEnabled;
  final List<RecipeInfo> recipeInfo;

  const MealPlannerCard({
    super.key,
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
      Here’s a list of existing meals:
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

    final gemini = Gemini.instance;
    final response = await gemini.prompt(parts: parts);
    print(response?.output);
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
