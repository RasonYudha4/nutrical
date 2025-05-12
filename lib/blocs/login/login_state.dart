part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isSubmitted = false,
    this.showValidationErrors = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isSubmitted;
  final bool showValidationErrors;
  final String? errorMessage;

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isSubmitted,
    bool? showValidationErrors,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid => Formz.validate([email, password]);

  @override
  List<Object?> get props => [email, password, status, isSubmitted, showValidationErrors, errorMessage];
}
