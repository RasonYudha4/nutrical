import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/analyze/analyze_page.dart';
import 'pages/home/home_page.dart';
import 'pages/recipe/recipe_page.dart';
import 'pages/profile/profile_page.dart';
import '../blocs/navigation/navigation_cubit.dart';
import 'widgets/navigation_bar.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          if (state.navbarItem == NavbarItem.home) {
            return HomePage();
          } else if (state.navbarItem == NavbarItem.recipe) {
            return RecipePage();
          } else if (state.navbarItem == NavbarItem.analyze) {
            return AnalyzePage();
          } else if (state.navbarItem == NavbarItem.profile) {
            return ProfilePage();
          }
          return Container();
        },
      ),
    );
  }
}
