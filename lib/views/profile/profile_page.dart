import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../data/models/User.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<User>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.amber),
            child: Text("Profile Page"),
          ),
          Container(child: Text(user.email!)),
          Container(
            height: 120,
            width: 200,
            decoration: BoxDecoration(color: Colors.blue),
            child: GestureDetector(
              onTap: () {
                context.read<AuthBloc>().add(const AuthLogoutPressed());
              },
            ),
          ),
        ],
      ),
    );
  }
}
