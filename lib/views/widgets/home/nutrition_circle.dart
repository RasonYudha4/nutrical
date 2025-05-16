import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NutritionCircle extends StatelessWidget {
  final double radius;
  final double lineWidth;
  final Color backgroundColor;
  final Color progressColor;
  final int value;
  final int limit;
  final bool isPercentage;
  final String category;

  const NutritionCircle({
    super.key,
    required this.radius,
    required this.lineWidth,
    required this.backgroundColor,
    required this.progressColor,
    required this.value,
    required this.limit,
    this.isPercentage = true,
    this.category = "calories",
  });

  @override
  Widget build(BuildContext context) {
    final safeLimit = limit == 0 ? 1 : limit;
    final percent = value / safeLimit;

    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      backgroundColor: backgroundColor,
      progressColor: progressColor,
      percent: math.min(1, percent),
      startAngle: 270,
      circularStrokeCap: CircularStrokeCap.round,
      center:
          isPercentage
              ? Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.toString(),
                    style: TextStyle(
                      color: getNutritionColor(value, safeLimit, category),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "/$limit gr",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
    );
  }
}

Color getNutritionColor(int value, int limit, String category) {
  Map<String, Color> colorMap = {
    "Good": const Color.fromARGB(255, 64, 155, 230),
    "Moderate": const Color(0xFFFFC107),
    "Bad": const Color(0xFFE53935),
  };

  double percentage = value / limit;

  if (category == "calories") {
    if (percentage >= 0.8 && percentage <= 1.0) {
      return colorMap["Good"]!;
    } else if (percentage > 1.0 && percentage <= 1.2) {
      return colorMap["Moderate"]!;
    } else {
      return colorMap["Bad"]!;
    }
  } else if (category == "protein") {
    if (percentage >= 0.9 && percentage <= 1.1) {
      return colorMap["Good"]!;
    } else if (percentage > 1.1 && percentage <= 1.3) {
      return colorMap["Moderate"]!;
    } else {
      return colorMap["Bad"]!;
    }
  } else if (category == "fats") {
    if (percentage >= 0.7 && percentage <= 1.0) {
      return colorMap["Good"]!;
    } else if (percentage > 1.0 && percentage <= 1.2) {
      return colorMap["Moderate"]!;
    } else {
      return colorMap["Bad"]!;
    }
  } else if (category == "carbs") {
    if (percentage >= 0.9 && percentage <= 1.1) {
      return colorMap["Good"]!;
    } else if (percentage > 1.1 && percentage <= 1.3) {
      return colorMap["Moderate"]!;
    } else {
      return colorMap["Bad"]!;
    }
  } else {
    return Colors.black;
  }
}
