class Meal {
  final String breakfast;
  final String lunch;
  final String dinner;
  final int day;

  Meal({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      day: map['day'],
      breakfast: map['breakfast'],
      lunch: map['lunch'],
      dinner: map['dinner'],
    );
  }
}
