import 'package:flutter/material.dart';

class MealTypeDropdown extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const MealTypeDropdown({super.key, this.onChanged});
  @override
  State<MealTypeDropdown> createState() => _MealTypeDropdownState();
}

class _MealTypeDropdownState extends State<MealTypeDropdown> {
  String selectedMeal = 'Breakfast';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Meal Type:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        DropdownButton<String>(
          value: selectedMeal,
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF89AC46)),
          dropdownColor: Color(0xFFF8ED8C),
          style: TextStyle(
            color: Color(0xFF89AC46),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          underline: Container(),
          borderRadius: BorderRadius.circular(12),
          items:
              ['Breakfast', 'Lunch', 'Dinner']
                  .map(
                    (meal) => DropdownMenuItem<String>(
                      value: meal,
                      child: Text(meal),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedMeal = value;
              });
              widget.onChanged!(value);
            }
          },
        ),
      ],
    );
  }
}
