import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/user_bloc.dart';
import '../../../data/enums/gender.dart';
import '../../../data/models/user.dart';
import '../../widgets/profile/activity_level_dropdown.dart';
import '../../widgets/profile/custom_textfield.dart';
import '../../widgets/profile/gender_selector.dart';
import '../../widgets/profile/small_custom_textfield.dart';
import '../../widgets/profile/success_dialog.dart';

class ChangeDetailPage extends StatefulWidget {
  final String userId;

  const ChangeDetailPage({super.key, required this.userId});

  @override
  State<ChangeDetailPage> createState() => _ChangeDetailPageState();
}

class _ChangeDetailPageState extends State<ChangeDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  Gender? selectedGender;
  int? activityLevel;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUserDetails(userId: widget.userId));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _updateFormFields(User user) {
    if (user.name != null) _nameController.text = user.name!;
    if (user.height != null) _heightController.text = user.height!.toString();
    if (user.weight != null) _weightController.text = user.weight!.toString();
    if (user.age != null) _ageController.text = user.age!.toString();

    setState(() {
      selectedGender = user.gender;
      activityLevel = user.activityLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            _updateFormFields(state.user);
          } else if (state is UserUpdated) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessDialog();
              },
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is UserInitial) {
            return const Center(child: Text("Loading..."));
          }

          return Column(
            children: [
              Container(
                color: const Color(0xffD3E671),
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        Navigator.pop(context, true);
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
                        ActivityLevelDropdown(
                          initialValue: activityLevel,
                          onChanged: (level) {
                            setState(() {
                              activityLevel = level;
                            });
                          },
                        ),
                        SizedBox(height: 100),
                        GestureDetector(
                          onTap:
                              state is UserLoading
                                  ? null
                                  : () => _saveUserDetails(context),
                          child: Container(
                            height: 60,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Color(0xFF89AC46),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child:
                                  state is UserLoading
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        "Save",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveUserDetails(BuildContext context) {
    // Input validation
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your name')));
      return;
    }

    if (selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select your gender')));
      return;
    }

    if (activityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your activity level')),
      );
      return;
    }

    // Parse numeric values with fallbacks
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);
    int? age = int.tryParse(_ageController.text);

    // Check numeric values
    if (_heightController.text.isNotEmpty && height == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid height')));
      return;
    }

    if (_weightController.text.isNotEmpty && weight == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid weight')));
      return;
    }

    if (_ageController.text.isNotEmpty && age == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid age')));
      return;
    }

    // Set defaults for empty fields
    height ??= 0.0;
    weight ??= 0.0;
    age ??= 0;

    // Dispatch event to bloc
    context.read<UserBloc>().add(
      UpdateUserDetails(
        userId: widget.userId,
        name: _nameController.text,
        gender: selectedGender!,
        age: age,
        height: height,
        weight: weight,
        activityLevel: activityLevel!,
      ),
    );
  }
}
