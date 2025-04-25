part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthUserSubscriptionRequested extends AuthEvent {
  const AuthUserSubscriptionRequested();
}

final class AuthLogoutPressed extends AuthEvent {
  const AuthLogoutPressed();
}
