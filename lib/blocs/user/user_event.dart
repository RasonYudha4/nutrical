part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetails extends UserEvent {
  final String userId;

  const FetchUserDetails({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserDetails extends UserEvent {
  final String userId;
  final String name;
  final Gender gender;
  final int age;
  final double height;
  final double weight;
  final int activityLevel;

  const UpdateUserDetails({
    required this.userId,
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  @override
  List<Object> get props => [
    userId,
    name,
    gender,
    age,
    height,
    weight,
    activityLevel,
  ];
}
