import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMealPlanner(),
                      const SizedBox(height: 55),
                      const Text(
                        'Monday',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMealCard(
                        mealType: 'Breakfast',
                        mealName: 'Soup',
                        ingredients: 'Ingredients : Rice, green onions, potatoes',
                        color: const Color(0xFF89AC46),
                      ),
                      const SizedBox(height: 12),
                      _buildMealCard(
                        mealType: 'Lunch',
                        mealName: 'Caesar Salad',
                        ingredients: 'Ingredients : Dried fruits, cheese, leafy greens, eggs',
                        color: const Color(0xFF89AC46),
                      ),
                      const SizedBox(height: 12),
                      _buildMealCard(
                        mealType: 'Dinner',
                        mealName: 'Pasta',
                        ingredients: 'Ingredients: Flour, salt, eggs',
                        color: const Color(0xFF89AC46),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Tuesday',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMealCard(
                        mealType: 'Breakfast',
                        mealName: 'Soup',
                        ingredients: 'Ingredients : Rice, green onions, potatoes',
                        color: const Color(0xFF89AC46),
                      ),
                      const SizedBox(height: 12),
                      _buildMealCard(
                        mealType: 'Lunch',
                        mealName: 'Salad',
                        ingredients: 'Ingredients : Dried fruits, leafy greens, eggs',
                        color: const Color(0xFF89AC46),
                      ),
                    ],
                  )
              )
          )
      ),
    );
  }

  Widget _buildMealPlanner() {
    return Container(
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
                      color: Colors.black.withOpacity(0.55),
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
                        Color(0xFF9BBB45),  // Lighter center
                        Color(0xFF7A9530),  // Darker edge
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
          const Divider(
            thickness: 2.2,
            color: Colors.black,
          ),
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
    );
  }

  Widget _buildMealCard({
    required String mealType,
    required String mealName,
    required String ingredients,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(),
                  ),
                ),
                const SizedBox(height: 0.8),
                Text(
                  mealName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 0.8),
                Text(
                  ingredients,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
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
