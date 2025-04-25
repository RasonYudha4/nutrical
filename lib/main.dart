import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_gate.dart';
import 'auth/bloc_observer.dart';
import 'auth/blocs/auth/auth_bloc.dart';
import 'packages/repositories/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp();

  final authenticationRepository = AuthRepo();
  await authenticationRepository.user.first;
  runApp(App(authenticationRepository: authenticationRepository));
}

class App extends StatelessWidget {
  const App({required AuthRepo authenticationRepository, super.key})
    : _authenticationRepository = authenticationRepository;

  final AuthRepo _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create:
            (_) =>
                AuthBloc(authenticationRepository: _authenticationRepository)
                  ..add(const AuthUserSubscriptionRequested()),
        child: const AuthGate(),
      ),
    );
  }
}
