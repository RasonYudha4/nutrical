import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String height;
  final String weight;
  final String bmi;

  const UserProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.bmi,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF89AC46),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(100, 0, 0, 0),
                spreadRadius: 1,
                offset: const Offset(4, 4),
                blurRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            top: 30,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "($email)",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(height, 'cm', 'Height'),
                    _buildStatItem(weight, 'kg', 'Weight'),
                    _buildStatItem(bmi, '', 'BMI'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -30,
          left: 34,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String unit, String label) {
    return Column(
      children: [
        Text(
          '$value $unit',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
