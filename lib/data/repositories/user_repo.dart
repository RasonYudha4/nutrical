import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/gender.dart';
import '../models/user.dart';

class UserRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> getUserById(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection("Users").doc(userId).get();

      if (!docSnapshot.exists) {
        throw Exception('User not found');
      }

      return User.fromFirestore(docSnapshot.data()!, userId);
    } catch (e) {
      throw Exception('Failed to get user details: ${e.toString()}');
    }
  }

  Future<void> updateUserDetail({
    required String userId,
    required String name,
    required Gender gender,
    required int age,
    required double height,
    required double weight,
    required int activityLevel,
  }) async {
    try {
      final docRef = _firestore.collection("Users").doc(userId);

      double bmr =
          (10 * weight) +
          (6.25 * height) -
          (5 * age) +
          (gender == Gender.male ? 5 : -161);

      double bmi = weight / ((height / 100) * (height / 100));

      final Map<String, dynamic> updateData = {
        'name': name,
        'gender': gender.toString().split('.').last,
        'age': age,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel,
        'bmr': bmr,
        'bmi': bmi,
      };

      await docRef.update(updateData);
    } catch (e) {
      throw Exception('Failed to update user details: ${e.toString()}');
    }
  }
}
