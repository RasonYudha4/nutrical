import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../data/form_inputs/auth/confirm_password.dart';
import '../../data/form_inputs/auth/email.dart';
import '../../data/form_inputs/auth/password.dart';
import '../../data/repositories/auth_repo.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

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
      confirmedPassword: ConfirmedPassword.dirty(
        password: password,
        value: state.confirmedPassword.value,
      ),
      showValidationErrors: false,
    ));
  }

  void confirmedPasswordChanged(String confirmedPassword) {
    emit(state.copyWith(
      confirmedPassword: ConfirmedPassword.dirty(
        password: state.password.value,
        value: confirmedPassword,
      ),
      showValidationErrors: false,
    ));
  }

  Future<void> signUpFormSubmitted() async {
    emit(state.copyWith(showValidationErrors: true));

    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authenticationRepository.signUp(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        String errorMessage;

      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Email already in use. Please use a different email.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An unknown error occurred. Please try again.';
      }

      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: errorMessage,
      ));
    }
  }
}
