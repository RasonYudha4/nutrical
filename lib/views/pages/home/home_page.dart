import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math' as math;
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../blocs/home/home_bloc.dart';
import '../../widgets/home/meal_type_card.dart';
import '../../widgets/home/meal_textfield.dart';
import '../../widgets/home/meal_type_dropdown.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final backgroundColor = const Color(0xFFD3E671);
  final primaryColor = const Color(0xFF89AC46);

  int carbs = 0;
  int proteins = 0;
  int fats = 0;
  int calories = 0;
  int caloriesLimit = 2229;
  int carbsLimit = 279;
  int proteinsLimit = 28;
  int fatsLimit = 74;
  String mealType = "Breakfast";
  final DatePickerController _datePickercontroller = DatePickerController();
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController servingSizeController = TextEditingController();
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
  void initState() {
    super.initState();
    servingSizeController.text = "1";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _datePickercontroller.jumpToSelection();
    });
    _onDateChange(DateTime.now());
    _loadPersonalDataFromFirebase();
  }

  @override
  void dispose() {
    mealNameController.dispose();
    servingSizeController.dispose();
    _dateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => HomeBloc()..add(LoadContents()),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16, top: 60),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
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
                            size: 30,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildNutritionSection(),
                        _buildDailyConsumptionsSection(),
                        _buildContentSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Nutrition Status",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            height: 110,
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
            child: DatePicker(
              DateTime.now().subtract(
                Duration(days: DateTime.now().weekday - DateTime.monday),
              ),
              controller: _datePickercontroller,
              initialSelectedDate: DateTime.now(),
              selectionColor: backgroundColor,
              selectedTextColor: Colors.white,
              daysCount: 7,
              onDateChange: _onDateChange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard() {
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Calories",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "${(caloriesLimit - calories).abs()}",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: getNutritionColor(
                                calories,
                                caloriesLimit,
                                "calories",
                              ),
                            ),
                          ),
                          Text(
                            (caloriesLimit - calories) >= 0
                                ? " kcal left"
                                : " kcal over",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "$calories ",
                            style: TextStyle(
                              fontSize: 20,
                              color: getNutritionColor(
                                calories,
                                caloriesLimit,
                                "calories",
                              ),
                            ),
                          ),
                          Text(
                            "/ $caloriesLimit kcal",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildNutritionCircle(
                    65,
                    15,
                    const Color.fromARGB(255, 238, 252, 185),
                    const Color.fromARGB(255, 35, 122, 18),
                    calories,
                    caloriesLimit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCircle(
    double radius,
    double lineWidth,
    Color backgroundColor,
    Color progressColor,
    int value,
    int limit, {
    bool isPercentage = true,
    String category = "calories",
  }) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      backgroundColor: const Color.fromARGB(255, 238, 252, 185),
      progressColor: progressColor,
      percent: math.min(1, value / limit),
      startAngle: 270,
      circularStrokeCap: CircularStrokeCap.round,
      center:
          isPercentage
              ? Text(
                "${(value / limit * 100).toInt()}%",
                style: TextStyle(
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
                      color: getNutritionColor(value, limit, category),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "/$limit gr",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildNutritionSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Subtract total horizontal padding (4 * 20 = 80)
        double cardWidth = (constraints.maxWidth - 80) / 3;

        return Column(
          children: [
            _buildNutritionHeader(),
            SizedBox(height: 20),
            _buildCaloriesCard(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNutritionCard(
                    "Carbs",
                    backgroundColor,
                    Colors.indigo,
                    carbs,
                    carbsLimit,
                    cardWidth,
                  ),
                  _buildNutritionCard(
                    "Protein",
                    backgroundColor,
                    Colors.deepOrange,
                    proteins,
                    proteinsLimit,
                    cardWidth,
                  ),
                  _buildNutritionCard(
                    "Fats",
                    backgroundColor,
                    Colors.amber,
                    fats,
                    fatsLimit,
                    cardWidth,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNutritionCard(
    String nutrition,
    Color backgroundColor,
    Color progressColor,
    int value,
    int limit,
    double width,
  ) {
    return Container(
      width: width,
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              nutrition,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            _buildNutritionCircle(
              width * 0.4,
              10,
              backgroundColor,
              progressColor,
              value,
              limit,
              isPercentage: false,
              category: nutrition.toLowerCase(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (limit - value).abs().toString(),
                  style: TextStyle(
                    color: getNutritionColor(
                      value,
                      limit,
                      nutrition.toLowerCase(),
                    ),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value > limit ? "gr over" : "gr left",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
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
            mealType: "Track your consumption",
            primaryColor: primaryColor,
            onTap: _showAddMealDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContentLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  height: 250,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.contents.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final content = state.contents[index];
                      return _buildContentCard(
                        content.title,
                        content.intro,
                        content.img,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is ContentLoadError) {
          return Center(child: Text("Error: ${state.message}"));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildContentCard(String title, String desc, String imageURL) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
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
                                color: Colors.white,
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
      ),
    );
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
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 20),
                      MealTypeDropdown(
                        onChanged: (value) {
                          setState(() {
                            mealType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _analyzeFood();
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

  bool containsError(Map<String, dynamic> geminiResponse) {
    return geminiResponse.containsKey("error");
  }

  void notifyError(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $error"), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _analyzeFood() async {
    try {
      final gemini = Gemini.instance;
      Candidates? result;
      do {
        result = await gemini.prompt(
          parts: [
            Part.text(
              '''Analyze the nutritional value of the food! Respond ONLY with a raw JSON object in this format:
            {
            "food_name": "Name of the food in proper name (No abbrevitations and such)" (String),
            "calories": Amount of calories in kcal (int),
            "carbohydrates": Amount of carbohydrates in grams (int),
            "proteins": Amount of proteins in grams (int),
            "fats": Amount of fats in grams (int),
            }
            Do not include any explanations, markdown formatting, or code block indicators (e.g., no ```json or backticks). Only respond with the raw JSON.
            You can add bold and italics markdown formatting to the "additional_info" field.
            If it is not a food or the food name is empty response with {"error": "Not a food"}
          ''',
            ),
            Part.text(
              "Food name: ${mealNameController.text}\nServing size: ${servingSizeController.text}",
            ),
          ],
          generationConfig: GenerationConfig(temperature: 0),
          model: "gemini-2.0-flash-exp-image-generation",
        );
      } while (!isJSON(result?.output ?? '{"error": "Not a food"}'));
      log(result?.output ?? "");
      Map<String, dynamic> geminiResponse = jsonDecode(result?.output ?? "");
      if (containsError(geminiResponse)) {
        notifyError(geminiResponse["error"]);
      }
      _saveToFirebase(
        geminiResponse["calories"],
        geminiResponse["carbohydrates"],
        geminiResponse["proteins"],
        geminiResponse["fats"],
        int.parse(servingSizeController.text),
        mealType,
      );
    } catch (e) {
      log("Gemini error: $e");
      notifyError("An error occurred when analyzing the food");
    }
  }

  bool isJSON(String geminiOutput) {
    try {
      jsonDecode(geminiOutput);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveToFirebase(
    int calories,
    int carbohydrates,
    int proteins,
    int fats,
    int servingSize,
    String mealType,
  ) async {
    Map<String, dynamic> data = {
      "calories": calories,
      "carbohydrates": carbohydrates,
      "proteins": proteins,
      "fats": fats,
      "serving_size": servingSize,
      "meal_type": mealType,
    };
    User? user = FirebaseAuth.instance.currentUser;
    String date = DateTime.now().toString().split(" ")[0];
    try {
      await FirebaseFirestore.instance
          .collection("Consumption")
          .doc("${user?.uid}")
          .collection(date)
          .add(data);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onDateChange(DateTime selectedDate) async {
    _dateListener?.cancel();
    _listenToDateCollection(selectedDate);
    await _loadFromFirebase(selectedDate);
  }

  Future<void> _loadPersonalDataFromFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user?.uid)
            .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data["height"] == null || data["weight"] == null) return;
    Map<int, double> activityMultiplier = {0: 1.2, 1: 1.375, 2: 1.55, 3: 1.725};
    double BMR =
        (10 * (data["weight"] as double)) +
        (6.25 * (data["height"] as double)) -
        (5 * (data["age"] as int)) +
        (data["gender"] == "male" ? 5 : -161);
    int TDEE =
        (BMR * activityMultiplier[data["activityLevel"] as int]!).toInt();
    log(TDEE.toString());
    int protein = (TDEE * 0.20 / 4).toInt();
    int fat = (TDEE * 0.30 / 4).toInt();
    int carbs = (TDEE * 0.50 / 4).toInt();
    setState(() {
      carbsLimit = carbs;
      proteinsLimit = protein;
      fatsLimit = fat;
      caloriesLimit = TDEE;
    });
  }

  Future<void> _loadFromFirebase(DateTime selectedDate) async {
    log("Load from firebase called");
    User? user = FirebaseAuth.instance.currentUser;
    String date = selectedDate.toString().split(" ")[0];
    num _carbs = 0, _proteins = 0, _fats = 0, _calories = 0;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("Consumption")
              .doc("${user?.uid}")
              .collection(date)
              .get();
      if (snapshot.docs.isEmpty) {
        if (!mounted) return;
        setState(() {
          carbs = 0;
          proteins = 0;
          fats = 0;
          calories = 0;
        });
        log("No data found");
        return;
      }
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        _carbs += doc["carbohydrates"] * doc["serving_size"];
        _proteins += doc["proteins"] * doc["serving_size"];
        _fats += doc["fats"] * doc["serving_size"];
        _calories += doc["calories"] * doc["serving_size"];
      }
      if (!mounted) return;
      setState(() {
        carbs = _carbs as int;
        proteins = _proteins as int;
        fats = _fats as int;
        calories = _calories as int;
      });
    } catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  StreamSubscription? _dateListener;

  void _listenToDateCollection(DateTime selectedDate) {
    User? user = FirebaseAuth.instance.currentUser;
    String date = selectedDate.toString().split(" ")[0];

    _dateListener = FirebaseFirestore.instance
        .collection("Consumption")
        .doc(user?.uid)
        .collection(date)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.docs.isEmpty) {
              setState(() {
                carbs = 0;
                proteins = 0;
                fats = 0;
                calories = 0;
              });
              log("No data found for date: $date");
              return;
            }

            num _carbs = 0, _proteins = 0, _fats = 0, _calories = 0;
            for (var doc in snapshot.docs) {
              Map<String, dynamic> data = doc.data();
              _carbs += data["carbohydrates"];
              _proteins += data["proteins"];
              _fats += data["fats"];
              _calories += data["calories"];
            }

            setState(() {
              carbs = _carbs.toInt();
              proteins = _proteins.toInt();
              fats = _fats.toInt();
              calories = _calories.toInt();
            });
            log("Updated values for $date");
          },
          onError: (error) {
            log("Listener error: $error");
          },
        );
  }

  Color getNutritionColor(int value, int limit, String category) {
    Map<String, Color> colorMap = {
      "Good": Color.fromARGB(255, 64, 155, 230),
      "Moderate": Color(0xFFFFC107),
      "Bad": Color(0xFFE53935),
    };
    double percentage = value / limit;
    log(percentage.toString());
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
}
