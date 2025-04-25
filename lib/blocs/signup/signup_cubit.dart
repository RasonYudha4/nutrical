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

  void emailChanged(String email) => emit(state.withEmail(email));

  void passwordChanged(String password) => emit(state.withPassword(password));

  void confirmedPasswordChanged(String confirmedPassword) {
    emit(state.withConfirmedPassword(confirmedPassword));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.withSubmissionInProgress());
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.withSubmissionSuccess());
    } catch (e) {
      emit(state.withSubmissionFailure());
    }
  }
}
