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

      final Map<String, dynamic> updateData = {
        'name': name,
        'gender': gender.toString().split('.').last,
        'age': age,
        'height': height,
        'weight': weight,
        'activityLevel': activityLevel,
      };

      await docRef.update(updateData);
    } catch (e) {
      throw Exception('Failed to update user details: ${e.toString()}');
    }
  }
}
