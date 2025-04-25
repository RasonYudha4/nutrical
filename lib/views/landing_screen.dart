import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'analyze/analyze_page.dart';
import 'home/home_page.dart';
import 'recipe/recipe_page.dart';
import 'profile/profile_page.dart';
import '../blocs/navigation/navigation_cubit.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.index,
            showUnselectedLabels: false,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,

            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.class_),
                label: 'Recipe',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: 'Analyze',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<NavigationCubit>(
                  context,
                ).getNavBarItem(NavbarItem.home);
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(
                  context,
                ).getNavBarItem(NavbarItem.recipe);
              } else if (index == 2) {
                BlocProvider.of<NavigationCubit>(
                  context,
                ).getNavBarItem(NavbarItem.analyze);
              } else if (index == 3) {
                BlocProvider.of<NavigationCubit>(
                  context,
                ).getNavBarItem(NavbarItem.profile);
              }
            },
          );
        },
      ),
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
