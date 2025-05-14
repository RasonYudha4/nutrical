import 'package:flutter/material.dart';

import '../../widgets/profile/activity_level_dropdown.dart';
import '../../widgets/profile/custom_textfield.dart';
import '../../widgets/profile/gender_selector.dart';
import '../../widgets/profile/small_custom_textfield.dart';

class ChangeDetailPage extends StatefulWidget {
  const ChangeDetailPage({super.key});

  @override
  State<ChangeDetailPage> createState() => _ChangeDetailPageState();
}

class _ChangeDetailPageState extends State<ChangeDetailPage> {
  final TextEditingController _nameController = TextEditingController(
    text: "Rason",
  );
  final TextEditingController _heightController = TextEditingController(
    text: '190.5',
  );
  final TextEditingController _weightController = TextEditingController(
    text: '90.5',
  );
  final TextEditingController _ageController = TextEditingController(
    text: '25',
  );
  Gender? selectedGender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: Column(
        children: [
          Container(
            color: const Color(0xffD3E671),
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Change Detail",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _nameController,
                  label: 'Your Name',
                ),
                SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallCustomTextfield(
                        label: 'Height',
                        controller: _heightController,
                      ),
                      SmallCustomTextfield(
                        label: 'Weight',
                        controller: _weightController,
                      ),
                      SmallCustomTextfield(
                        label: 'Age',
                        controller: _ageController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                GenderSelector(
                  selectedGender: selectedGender,
                  onChanged: (gender) {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                ),
                SizedBox(height: 30),
                ActivityLevelDropdown(),
                SizedBox(height: 100),
                GestureDetector(
                  child: Container(
                    height: 60,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Color(0xFF89AC46),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
