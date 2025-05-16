import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/consumption/consumption_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../widgets/home/calories_card.dart';
import '../../widgets/home/content_card.dart';
import '../../widgets/home/meal_dialog.dart';
import '../../widgets/home/meal_type_card.dart';
import '../../widgets/home/nutrition_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  }

  @override
  void dispose() {
    mealNameController.dispose();
    servingSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ContentBloc()..add(LoadContents())),
          BlocProvider(
            create:
                (context) =>
                    ConsumptionBloc()..add(
                      StreamConsumptions(userId: user.id, date: DateTime.now()),
                    ),
          ),
          BlocProvider(
            create:
                (context) =>
                    UserBloc(userId: user.id)
                      ..add(FetchUserDetails(userId: user.id)),
          ),
        ],
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFD3E671),
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
                            color: Color(0xFF89AC46),
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
          Container(
            padding: EdgeInsets.all(10),
            height: 110,
            decoration: BoxDecoration(
              color: Color(0xFF89AC46),
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
            child: Builder(
              builder: (context) {
                final userId = context.read<AuthBloc>().state.user.id;

                return DatePicker(
                  DateTime.now().subtract(
                    Duration(days: DateTime.now().weekday - DateTime.monday),
                  ),
                  controller: _datePickercontroller,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Color(0xFFD3E671),
                  selectedTextColor: Colors.black,
                  daysCount: 7,
                  onDateChange: (selectedDate) {
                    context.read<ConsumptionBloc>().add(
                      StreamConsumptions(userId: userId, date: selectedDate),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - 80) / 3;

        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            double bmr = 0;
            int activityLevel = 0;

            if (userState is UserLoaded) {
              bmr = userState.user.bmr ?? 0;
              activityLevel = userState.user.activityLevel ?? 0;
            }

            final Map<int, double> activityMultiplier = {
              0: 1.2,
              1: 1.375,
              2: 1.55,
              3: 1.725,
            };

            final double multiplier = activityMultiplier[activityLevel] ?? 1.2;
            final int tdee = (bmr * multiplier).toInt();

            final int proteinsLimit = (tdee * 0.20 / 4).toInt();
            final int fatsLimit = (tdee * 0.30 / 9).toInt(); // 9 for fats
            final int carbsLimit = (tdee * 0.50 / 4).toInt();

            return BlocBuilder<ConsumptionBloc, ConsumptionState>(
              builder: (context, ConsumptionState) {
                int carbs = 0;
                int proteins = 0;
                int fats = 0;
                int calories = 0;

                if (ConsumptionState is ConsumptionLoaded) {
                  final summary = ConsumptionState.nutritionSummary;
                  carbs = summary.carbs;
                  proteins = summary.proteins;
                  fats = summary.fats;
                  calories = summary.calories;
                }

                return Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Nutrition Status",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildNutritionHeader(),
                    const SizedBox(height: 20),
                    CaloriesCard(calories: calories, caloriesLimit: tdee),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NutritionCard(
                            nutrition: "Carbs",
                            progressColor: Colors.indigo,
                            value: carbs,
                            limit: carbsLimit,
                            width: cardWidth,
                          ),
                          NutritionCard(
                            nutrition: "Protein",
                            progressColor: Colors.deepOrange,
                            value: proteins,
                            limit: proteinsLimit,
                            width: cardWidth,
                          ),
                          NutritionCard(
                            nutrition: "Fats",
                            progressColor: Colors.amber,
                            value: fats,
                            limit: fatsLimit,
                            width: cardWidth,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDailyConsumptionsSection() {
    return BlocBuilder<ConsumptionBloc, ConsumptionState>(
      builder: (context, state) {
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
                primaryColor: Color(0xFF89AC46),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocProvider(
                        create: (context) => ConsumptionBloc(),
                        child: MealRecordDialog(
                          mealNameController: mealNameController,
                          servingSizeController: servingSizeController,
                          mealType: mealType,
                          onMealTypeChanged: (value) {
                            setState(() {
                              mealType = value!;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection() {
    return BlocBuilder<ContentBloc, ContentState>(
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
                      return ContentCard(
                        title: content.title,
                        desc: content.intro,
                        imageURL: content.img,
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
}
