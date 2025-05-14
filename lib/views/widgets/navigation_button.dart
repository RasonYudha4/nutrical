import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/navigation/navigation_cubit.dart';
import '../../config/size_config.dart';
import '../../data/enums/navbar_items.dart';

class NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final NavbarItem navItem;

  const NavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.navItem,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = SizeConfig.width(20).clamp(22.0, 30.0);
    final double buttonSize = SizeConfig.blockSizeHorizontal * 25;

    return InkWell(
      onTap: () {
        BlocProvider.of<NavigationCubit>(context).getNavBarItem(navItem);
      },
      child: SizedBox(
        height: buttonSize,
        width: buttonSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFF89AC46) : Colors.grey,
              size: iconSize,
            ),
            const SizedBox(height: 4),
            Text(
              isSelected ? label : '',
              style: TextStyle(
                color: Color(0xFF89AC46),
                fontSize: SizeConfig.fontSize(13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
