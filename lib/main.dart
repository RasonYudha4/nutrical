import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'config/api_keys.dart';
import 'config/logging_setup.dart';
import 'views/auth_gate.dart';
import 'blocs/bloc_observer.dart';
import 'blocs/auth/auth_bloc.dart';
import 'data/repositories/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp();

  final authenticationRepository = AuthRepo();
  await authenticationRepository.user.first;
  Gemini.init(apiKey: ApiKeys.geminiApiKey);
  runApp(App(authenticationRepository: authenticationRepository));
}

class App extends StatelessWidget {
  const App({required AuthRepo authenticationRepository, super.key})
    : _authenticationRepository = authenticationRepository;

  final AuthRepo _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: _authenticationRepository)],
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
