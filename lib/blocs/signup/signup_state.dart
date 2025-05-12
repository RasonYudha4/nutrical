part of 'signup_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.showValidationErrors = false,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool showValidationErrors;

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? showValidationErrors,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
    );
  }

  bool get isValid => Formz.validate([email, password, confirmedPassword]);

  @override
  List<Object?> get props => [
    email,
    password,
    confirmedPassword,
    status,
    errorMessage,
    showValidationErrors,
  ];
}
