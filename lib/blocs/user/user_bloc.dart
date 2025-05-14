import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/enums/gender.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo _userRepository = UserRepo();

  UserBloc({required String userId}) : super(UserInitial()) {
    on<UpdateUserDetails>(_onUpdateUserDetails);
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final user = await _userRepository.getUserById(event.userId);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserDetails(
    UpdateUserDetails event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());

      await _userRepository.updateUserDetail(
        userId: event.userId,
        name: event.name,
        gender: event.gender,
        age: event.age,
        height: event.height,
        weight: event.weight,
        activityLevel: event.activityLevel,
      );

      emit(UserUpdated());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
