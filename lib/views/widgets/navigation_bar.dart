import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/navigation/navigation_cubit.dart';
import '../../config/size_config.dart';
import '../../data/enums/navbar_items.dart';
import 'navigation_button.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double navBarHeight = SizeConfig.height(8.5);
    final double safeNavBarHeight = navBarHeight.clamp(100.0, 120.0);
    final double barWidth = SizeConfig.blockSizeHorizontal * 15;
    final double barHeight = SizeConfig.blockSizeVertical * 1;
    final List<double> barPosition = [
      SizeConfig.blockSizeHorizontal * 5,
      SizeConfig.blockSizeHorizontal * 30,
      SizeConfig.blockSizeHorizontal * 55,
      SizeConfig.blockSizeHorizontal * 80,
    ];

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Container(
          height: safeNavBarHeight,
          decoration: BoxDecoration(color: Color(0xFFD3E671)),

          child: Stack(
            children: [
              AnimatedPositioned(
                left: barPosition[state.navbarItem.index],
                duration: Duration(milliseconds: 250),
                child: Container(
                  height: barHeight,
                  width: barWidth,
                  decoration: BoxDecoration(
                    color: Color(0xFF89AC46),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavButton(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isSelected: state.navbarItem == NavbarItem.home,
                    navItem: NavbarItem.home,
                  ),
                  NavButton(
                    icon: Icons.class_,
                    label: 'Recipe',
                    isSelected: state.navbarItem == NavbarItem.recipe,
                    navItem: NavbarItem.recipe,
                  ),
                  NavButton(
                    icon: Icons.camera_alt,
                    label: 'Analyze',
                    isSelected: state.navbarItem == NavbarItem.analyze,
                    navItem: NavbarItem.analyze,
                  ),
                  NavButton(
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: state.navbarItem == NavbarItem.profile,
                    navItem: NavbarItem.profile,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
