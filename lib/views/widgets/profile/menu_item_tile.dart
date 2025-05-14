import 'package:flutter/material.dart';

class MenuItemTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MenuItemTile({Key? key, required this.title, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}
