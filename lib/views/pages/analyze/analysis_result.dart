import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class AnalysisResult extends StatelessWidget {
  final Map<String, dynamic> geminiResponse;
  final VoidCallback? onPressedYes;
  final VoidCallback? onPressedNo;
  const AnalysisResult({
    super.key,
    required this.geminiResponse,
    this.onPressedYes,
    this.onPressedNo,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF89AC46),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      geminiResponse["food_name"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Main Ingredients: ${geminiResponse["main_ingredients"].join(", ")}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Calories: ${geminiResponse["calories"]} kcal",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Proteins: ${geminiResponse["proteins"]} g",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Fats: ${geminiResponse["fats"]} g",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Minerals: ${geminiResponse["minerals"].join(", ")}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  GptMarkdown(
                    geminiResponse["additional_info"],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Would you like to save this to today's nutrition log?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Yes"),
                onPressed: () {
                  if (onPressedYes != null) {
                    onPressedYes!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF89AC46),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                child: Text("No"),
                onPressed: () {
                  if (onPressedNo != null) {
                    onPressedNo!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 175, 18, 18),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
