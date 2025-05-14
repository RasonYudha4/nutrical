import 'package:equatable/equatable.dart';
import '../enums/gender.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.activityLevel,
  });

  final String id;
  final String? email;
  final String? name;
  final String? photo;
  final double? height;
  final double? weight;
  final int? age;
  final Gender? gender;
  final int? activityLevel; // 0-3 corresponding to activity levels

  static const empty = User(id: '');

  /// Factory method to create a User from Firestore data
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    // Parse gender from string to enum if it exists
    Gender? gender;
    if (data['gender'] != null) {
      gender = data['gender'] == 'male' ? Gender.male : Gender.female;
    }

    return User(
      id: id,
      email: data['email'],
      name: data['name'],
      photo: data['photo'],
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      age: data['age'],
      gender: gender,
      activityLevel: data['activityLevel'],
    );
  }

  bool get hasCompletedProfile {
    return name != null &&
        height != null &&
        weight != null &&
        age != null &&
        gender != null &&
        activityLevel != null;
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photo,
    double? height,
    double? weight,
    int? age,
    Gender? gender,
    int? activityLevel,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    photo,
    height,
    weight,
    age,
    gender,
    activityLevel,
  ];
}
