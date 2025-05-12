import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../data/form_inputs/auth/email.dart';
import '../../data/form_inputs/auth/password.dart';
import '../../data/repositories/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthRepo _authenticationRepository;

  void emailChanged(String email) {
    emit(state.copyWith(
      email: Email.dirty(email),
      showValidationErrors: false,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: Password.dirty(password),
      showValidationErrors: false,
    ));
  }

  Future<void> logInWithCredentials() async {
    emit(state.copyWith(showValidationErrors: true, isSubmitted: true));

    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authenticationRepository.logIn(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      String errorMessage;

      if (e.toString().contains('user-not-found')) {
        errorMessage = 'User not found. Please check your credentials.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }

      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: errorMessage,
      ));
    }
  }
}
