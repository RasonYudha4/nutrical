import 'package:flutter/material.dart';

class MealText extends StatelessWidget {
  final String text;
  final IconData icon;
  const MealText({Key? key, required this.text, required this.icon})
    : super(key: key);

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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                text.isEmpty ? "" : text,
                style: TextStyle(
                  fontSize: 16,
                  color: text.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
