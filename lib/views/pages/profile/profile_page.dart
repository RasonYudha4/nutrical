import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../data/models/user.dart';
import '../../widgets/profile/menu_item_tile.dart';
import '../../widgets/profile/user_profile_card.dart';
import 'about_page.dart';
import 'change_detail_page.dart';
import 'faq_page.dart';
import 'help_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<User>();
    return Scaffold(
      body: BlocProvider(
        create:
            (context) =>
                UserBloc(userId: user.id)
                  ..add(FetchUserDetails(userId: user.id)),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(color: const Color(0xFFD3E671)),
                ),
                Expanded(
                  flex: 7,
                  child: Container(color: const Color(0xFFD9D9D9)),
                ),
              ],
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 45.0,
                          left: 25.0,
                          right: 25.0,
                        ),
                        child: Column(
                          children: [
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is UserLoaded) {
                                  return UserProfileCard(
                                    name: state.user.name ?? "-",
                                    email: state.user.email ?? "-",
                                    height:
                                        state.user.height?.toString() ?? "-",
                                    weight:
                                        state.user.weight?.toString() ?? "-",
                                    bmi:
                                        state.user.bmi?.toStringAsFixed(1) ??
                                        "-",
                                  );
                                } else {
                                  return UserProfileCard(
                                    name: "-",
                                    email: user.email!,
                                    height: "-",
                                    weight: "-",
                                    bmi: "-",
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 40),
                            MenuItemTile(
                              title: 'Change Details',
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return BlocProvider<UserBloc>(
                                        create:
                                            (context) =>
                                                UserBloc(userId: user.id),
                                        child: ChangeDetailPage(
                                          userId: user.id,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            MenuItemTile(
                              title: 'FAQ',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return FaqPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            MenuItemTile(
                              title: 'About Nutrical',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return AboutPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            MenuItemTile(
                              title: 'Help',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return HelpPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            MenuItemTile(
                              title: 'Log Out',
                              onTap: () {
                                context.read<AuthBloc>().add(
                                  const AuthLogoutPressed(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
