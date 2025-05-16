import 'package:equatable/equatable.dart';
import '../enums/gender.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photo;
  final double? height;
  final double? weight;
  final int? age;
  final Gender? gender;
  final int? activityLevel;
  final double? bmr;
  final double? bmi;

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
    this.bmr,
    this.bmi,
  });

  static const empty = User(id: '');

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
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
      bmr: data['bmr']?.toDouble(),
      bmi: data['bmi']?.toDouble(),
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
    double? bmr,
    double? bmi,
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
      bmr: bmr ?? this.bmr,
      bmi: bmi ?? this.bmi,
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
    bmr,
    bmi,
  ];
}
