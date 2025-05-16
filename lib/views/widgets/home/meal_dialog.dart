import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/consumption/consumption_bloc.dart';
import '../../../data/models/consumption.dart';
import '../analyze/meal_textfield.dart';
import 'failed_dialog.dart';
import 'meal_type_dropdown.dart' show MealTypeDropdown;

class MealRecordDialog extends StatelessWidget {
  final TextEditingController mealNameController;
  final TextEditingController servingSizeController;
  final String? mealType;
  final Function(String?) onMealTypeChanged;

  const MealRecordDialog({
    super.key,
    required this.mealNameController,
    required this.servingSizeController,
    required this.mealType,
    required this.onMealTypeChanged,
  });

  Future<void> submit(BuildContext context) async {
    final user = context.read<AuthBloc>().state.user;
    final userId = user.id;
    final inputText = mealNameController.text.trim();
    final servingSize = int.tryParse(servingSizeController.text) ?? 0;
    final currentMealType = mealType;

    if (inputText.isEmpty || currentMealType == null) return;

    const promptText = '''
Analyze the nutritional value of the food! Respond ONLY with a raw JSON object in this format:
{
  "food_name": "Name of the food in proper name (No abbrevitations and such)" (String),
  "calories": Amount of calories in kcal (int),
  "carbohydrates": Amount of carbohydrates in grams (int),
  "proteins": Amount of proteins in grams (int),
  "fats": Amount of fats in grams (int)
}
Do not include any explanations, markdown formatting, or code block indicators (e.g., no ```json or backticks). Only respond with the raw JSON.
You can add bold and italics markdown formatting to the "additional_info" field.
If it is not a food or the food name is empty respond with {"error": "Not a food"}
''';

    final parts = [
      Part.text(promptText),
      Part.text("Food name: $inputText\nServing size: $servingSize"),
    ];

    final gemini = Gemini.instance;
    final response = await gemini.prompt(parts: parts);

    if (response?.output == null || !context.mounted) return;

    try {
      final geminiResponse = jsonDecode(response!.output!);
      if (geminiResponse['error'] != null) return;

      final consumption = Consumption.fromGeminiResponse(
        map: geminiResponse,
        servingSize: servingSize,
        mealType: currentMealType,
      );

      final date = DateTime.now();

      context.read<ConsumptionBloc>().add(
        SaveConsumption(userId: userId, date: date, consumption: consumption),
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return FailedDialog();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E671),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Record Your Consumption",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  MealTextField(
                    icon: Icons.local_dining_rounded,
                    hintText: "Meal name",
                    controller: mealNameController,
                  ),
                  const SizedBox(height: 20),
                  MealTextField(
                    icon: Icons.dinner_dining,
                    hintText: "Serving estimation",
                    controller: servingSizeController,
                    keyboardType: TextInputType.number,
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),
                  MealTypeDropdown(
                    onChanged: onMealTypeChanged,
                    value: mealType,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                submit(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF89AC46),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Add",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
