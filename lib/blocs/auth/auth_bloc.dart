import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutrical/data/repositories/auth_repo.dart';

import '../../data/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepo authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(AuthState(user: authenticationRepository.currentUser)) {
    on<AuthUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AuthLogoutPressed>(_onLogoutPressed);
  }

  final AuthRepo _authenticationRepository;

  Future<void> _onUserSubscriptionRequested(
    AuthUserSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) => emit(AuthState(user: user)),
      onError: addError,
    );
  }

  void _onLogoutPressed(AuthLogoutPressed event, Emitter<AuthState> emit) {
    _authenticationRepository.logOut();
  }
}
