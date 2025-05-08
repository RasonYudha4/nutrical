import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math' as math;

import '../../widgets/home/meal_type_card.dart';
import '../../widgets/home/meal_textfield.dart';
import '../../widgets/home/meal_type_dropdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colors
  final backgroundColor = const Color(0xFFD3E671);
  final primaryColor = const Color(0xFF89AC46);

  // Nutrition data
  int carbs = 200;
  int proteins = 18;
  int fats = 180;
  int calories = 300;
  int caloriesLimit = 380;

  // Text controllers
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController proteinsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController caloriesLimitController = TextEditingController();

  // Text styles
  final TextStyle nutritionTextStyle = const TextStyle(
    fontSize: 15,
    letterSpacing: 0.2,
  );

  final TextStyle nutritionValueStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with background color
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: backgroundColor,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(100, 0, 0, 0),
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'NutriCal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  _buildNutritionSummary(),
                  _buildDailyConsumptionsSection(),
                  _buildContentSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              spreadRadius: 1,
              offset: Offset(2, 2),
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSummaryHeader(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildNutrientsList(), _buildCaloriesCircle()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Nutrition Summarization",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        IconButton(
          onPressed: _showEditDialog,
          icon: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  spreadRadius: 1,
                  offset: Offset(2, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: Row(
                children: [
                  Text(
                    "Edit",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.edit, size: 15),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNutrientRow("Carbs :", carbs),
        const SizedBox(height: 5),
        _buildNutrientRow("Proteins :", proteins),
        const SizedBox(height: 5),
        _buildNutrientRow("Fats :", fats),
      ],
    );
  }

  // Single nutrient row
  Widget _buildNutrientRow(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: nutritionTextStyle),
        Row(
          children: [
            const SizedBox(width: 12),
            Text(value.toString(), style: nutritionValueStyle),
            Text(" g", style: nutritionValueStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildCaloriesCircle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Calories :", style: nutritionTextStyle),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 15),
          child: CircularPercentIndicator(
            radius: 70,
            lineWidth: 15,
            backgroundColor: const Color.fromARGB(255, 238, 252, 185),
            progressColor: backgroundColor,
            percent: math.min(1, calories / caloriesLimit),
            startAngle: 270,
            circularStrokeCap: CircularStrokeCap.round,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(calories.toString(), style: nutritionValueStyle),
                    Text(" Cal", style: nutritionValueStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("/", style: nutritionTextStyle),
                    Text(caloriesLimit.toString(), style: nutritionTextStyle),
                    Text(" Cal", style: nutritionTextStyle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyConsumptionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Daily Consumptions",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          MealTypeCard(
            mealType: "Breakfast",
            primaryColor: primaryColor,
            onTap: _showAddMealDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Contents",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 250, // Fixed height for the scrollable content
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildContentCard(
                  "Healthy Eating",
                  "Making smart food choices doesn't mean sacrificing flavor.",
                  "https://imgsrv2.voi.id/4UB_YXWr4rIKQoUdb4PugkW-e3ZDEX5cS2rDM4NQjco/auto/336/188/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yNTM3MzEvMjAyMzAyMTMxMzAzLW1haW4uanBn.jpg",
                ),
                const SizedBox(width: 10),
                _buildContentCard(
                  "Healthy Eating",
                  "Making smart food choices doesn't mean sacrificing flavor.",
                  "https://imgsrv2.voi.id/4UB_YXWr4rIKQoUdb4PugkW-e3ZDEX5cS2rDM4NQjco/auto/336/188/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yNTM3MzEvMjAyMzAyMTMxMzAzLW1haW4uanBn.jpg",
                ),
                const SizedBox(width: 10),
                _buildContentCard(
                  "Healthy Eating",
                  "Making smart food choices doesn't mean sacrificing flavor.",
                  "https://imgsrv2.voi.id/4UB_YXWr4rIKQoUdb4PugkW-e3ZDEX5cS2rDM4NQjco/auto/336/188/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8yNTM3MzEvMjAyMzAyMTMxMzAzLW1haW4uanBn.jpg",
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content card for articles
  Widget _buildContentCard(String title, String desc, String imageURL) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(100, 0, 0, 0),
            spreadRadius: 1,
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageURL,
              fit: BoxFit.cover,
              height: 200,
              width: 350,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.error)),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            desc,
                            style: const TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () {
                            debugPrint("Read more");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          child: const Text(
                            "Read more",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show edit nutrition dialog
  void _showEditDialog() {
    carbsController.text = carbs.toString();
    proteinsController.text = proteins.toString();
    fatsController.text = fats.toString();
    caloriesController.text = calories.toString();
    caloriesLimitController.text = caloriesLimit.toString();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(100, 0, 0, 0),
                    spreadRadius: 1,
                    offset: Offset(2, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Nutrition Summarization",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEditableNutrientsList(),
                            _buildEditableCaloriesCircle(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _saveNutritionData();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }

  // Editable nutrients list
  Widget _buildEditableNutrientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditableNutrientRow("Carbs :", carbsController),
        const SizedBox(height: 5),
        _buildEditableNutrientRow("Proteins :", proteinsController),
        const SizedBox(height: 5),
        _buildEditableNutrientRow("Fats :", fatsController),
      ],
    );
  }

  // Single editable nutrient row
  Widget _buildEditableNutrientRow(
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: nutritionTextStyle),
        Row(
          children: [
            const SizedBox(width: 12),
            Container(
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFD3E671),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                ),
              ),
            ),
            Text(" g", style: nutritionValueStyle),
          ],
        ),
      ],
    );
  }

  // Editable calories circle
  Widget _buildEditableCaloriesCircle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Calories :", style: nutritionTextStyle),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 15),
          child: CircularPercentIndicator(
            radius: 70,
            lineWidth: 15,
            backgroundColor: const Color.fromARGB(255, 238, 252, 185),
            progressColor: backgroundColor,
            percent: math.min(1, (calories / caloriesLimit)),
            startAngle: 270,
            circularStrokeCap: CircularStrokeCap.round,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3E671),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                        ),
                      ),
                    ),
                    Text(" Cal", style: nutritionValueStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("/", style: nutritionTextStyle),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3E671),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: caloriesLimitController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                        ),
                      ),
                    ),
                    Text(" Cal", style: nutritionTextStyle),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Save nutrition data from the edit dialog
  void _saveNutritionData() {
    setState(() {
      carbs = int.parse(carbsController.text);
      proteins = int.parse(proteinsController.text);
      fats = int.parse(fatsController.text);
      calories = int.parse(caloriesController.text);
      caloriesLimit = int.parse(caloriesLimitController.text);
    });
  }

  // Show add meal dialog
  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      MealTextField(
                        icon: Icons.local_dining_rounded,
                        hintText: "Meal name",
                      ),
                      SizedBox(height: 20),
                      MealTextField(
                        icon: Icons.dinner_dining,
                        hintText: "Serving estimation",
                      ),
                      SizedBox(height: 20),
                      MealTypeDropdown(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
