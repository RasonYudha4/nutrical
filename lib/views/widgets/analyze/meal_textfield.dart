import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController? controller;
  final List<TextInputFormatter> inputFormatter;
  final TextInputType keyboardType;
  const MealTextField({
    super.key,
    required this.icon,
    required this.hintText,
    this.controller,
    this.inputFormatter = const [],
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8ED8C),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Container(height: 24, width: 1, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              inputFormatters: inputFormatter,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
