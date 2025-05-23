import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrical/blocs/navigation/navigation_cubit.dart';
import 'package:provider/provider.dart';

import '../blocs/auth/auth_bloc.dart';
import '../config/size_config.dart';
import '../data/enums/authstatus.dart';
import '../data/models/user.dart';
import 'pages/landing_screen.dart';
import 'pages/auth/login/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return MaterialApp(
      home: Builder(
        builder: (context) {
          SizeConfig.init(context);
          return FlowBuilder<AuthStatus>(
            state: context.select((AuthBloc bloc) => bloc.state.status),
            onGeneratePages: (status, _) {
              switch (status) {
                case AuthStatus.authenticated:
                  return [
                    MaterialPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (_) => NavigationCubit()),
                        ],
                        child: Provider<User>.value(
                          value: user,
                          child: const LandingScreen(),
                        ),
                      ),
                    ),
                  ];
                case AuthStatus.unauthenticated:
                  return [LoginPage.page()];
              }
            },
          );
        },
      ),
    );
  }
}
