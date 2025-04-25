import 'package:formz/formz.dart';

class ConfirmedPassword extends FormzInput<String, String> {
  final String password;

  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
    : super.dirty(value);

  @override
  String? validator(String value) {
    if (value.isEmpty) return 'Confirm password cannot be empty';
    if (value != password) return 'Passwords do not match';
    return null;
  }
}
