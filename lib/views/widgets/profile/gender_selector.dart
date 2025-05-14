import 'package:flutter/material.dart';

enum Gender { male, female }

class GenderSelector extends StatefulWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender?>? onChanged;

  const GenderSelector({super.key, this.selectedGender, this.onChanged});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  Gender? _gender;

  @override
  void initState() {
    super.initState();
    _gender = widget.selectedGender ?? Gender.male;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRadio(Gender.male, 'Male'),
        const SizedBox(width: 24),
        _buildRadio(Gender.female, 'Female'),
      ],
    );
  }

  Widget _buildRadio(Gender gender, String label) {
    return Row(
      children: [
        Radio<Gender>(
          value: gender,
          groupValue: _gender,
          onChanged: (value) {
            setState(() => _gender = value);
            widget.onChanged?.call(value);
          },
          fillColor: WidgetStateProperty.all(Colors.black),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
