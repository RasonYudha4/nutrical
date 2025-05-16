import 'package:flutter/material.dart';

class FailedDialog extends StatelessWidget {
  const FailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF89AC46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.warning_amber, size: 60, color: Color(0xFFD3E671)),
          SizedBox(height: 16),
          Text(
            "Failed to connect with Gemini",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFD3E671),
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
