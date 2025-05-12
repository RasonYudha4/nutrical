import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../../data/form_inputs/auth/email.dart'; 
import '../../../../data/form_inputs/auth/password.dart'; 
import '../../../../blocs/login/login_cubit.dart';
import '../signup/signup_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {},
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFD3E671),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 85),
                Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF89AC46),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.50),
                      offset: const Offset(5, 6),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/logo.jpeg',  
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 45),
              Center(
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 6.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _EmailInput(),
                    const SizedBox(height: 24),
                    _PasswordInput(),
                    const SizedBox(height: 32),
                    _LoginErrorText(),
                    const SizedBox(height: 24),
                    _LoginButton(),
                    const SizedBox(height: 15),
                    _SignUpButton(),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((LoginCubit cubit) => cubit.state);
    final showError = state.showValidationErrors && !state.email.isValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(17),
          ),
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 8.0),
                    child: Icon(Icons.mail_outline, color: Colors.grey),
                  ),
                  Container(
                    height: 24.0,
                    width: 1.0,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
              hintText: 'Email',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              _getEmailErrorMessage(state.email),
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  String _getEmailErrorMessage(Email email) {
    if (email.error?.toString() == 'EmailValidationError.empty') {
      return "Email can't be empty";
    } else if (email.error?.toString() == 'EmailValidationError.invalid') {
      return "Please enter a valid email address";
    } else {
      return "An error occurred. Please try again.";
    }
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((LoginCubit cubit) => cubit.state);
    final showError = state.showValidationErrors && !state.password.isValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(17),
          ),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 8.0),
                    child: Icon(Icons.key, color: Colors.grey),
                  ),
                  Container(
                    height: 24.0,
                    width: 1.0,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
              hintText: 'Password',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
        
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              _getPasswordErrorMessage(state.password),
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  String _getPasswordErrorMessage(Password password) {
    if (password.value.isEmpty) {
      return "Password can't be empty";
    } else if (password.value.length < 6) {
      return "Password must be at least 6 characters";
    } else {
      return "Invalid password format";
    }
  }
}

class _LoginErrorText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((LoginCubit cubit) => cubit.state);
    final isFailure = state.status.isFailure;

    return isFailure
        ? Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              state.errorMessage ?? "Login failed. Please try again.",
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((LoginCubit cubit) => cubit.state);
    final isInProgress = state.status.isInProgress;

    if (isInProgress) return const CircularProgressIndicator();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('loginForm_continue_raisedButton'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFF89AC46),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          overlayColor: MaterialStateProperty.all(Colors.black12),
        ),
        onPressed: () => context.read<LoginCubit>().logInWithCredentials(),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account yet? ",
          style: TextStyle(color: Colors.black87),
        ),
        GestureDetector(
          key: const Key('loginForm_createAccount_flatButton'),
          onTap: () => Navigator.of(context).push<void>(SignUpPage.route()),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.pink[400],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
