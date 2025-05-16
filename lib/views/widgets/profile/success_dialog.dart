import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String content;

  const SuccessDialog({
    super.key,
    this.title = 'Success',
    this.content = 'Your details have been updated successfully.',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF89AC46),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFD3E671),
          fontSize: 24,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(color: Color(0xFFD3E671), fontSize: 20),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(color: Color(0xFFD3E671), fontSize: 20),
          ),
        ),
      ],
    );
  }
}
