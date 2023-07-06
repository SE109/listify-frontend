import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/auth/auth_bloc.dart';
import 'package:listify/blocs/login/login_bloc.dart';
import 'package:listify/constants/app_constants.dart';

import '../../../blocs/user/user_bloc.dart';
import '../../../routes/app_routes.dart';
import '../settings/theme_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(const GetInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserLoaded) {
            return SafeArea(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/images/logo_3.png",
                        scale: 3.5,
                      )),
                  Center(
                    child: EditableCircleAvatar(
                      imageUrl: state.user.avatar,
                      size: 110,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.updateProfile,
                            arguments: state.user);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${state.user.firstName} ${state.user.lastName}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(state.user.phoneNum,
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  ItemProfile(
                      leftIcon: Icons.lock,
                      label: "Change Password",
                      onPress: () {
                        Navigator.pushNamed(context, AppRoutes.changePassWord);
                      }),
                  const CustomDivider(),
                  ItemProfile(
                      leftIcon: Icons.edit,
                      label: "Theme Setting",
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThemeScreen()));
                      }),
                  const CustomDivider(),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return ItemProfile(
                        leftIcon: Icons.logout,
                        label: "Log Out",
                        onPress: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(const ButtonLogoutPressed());
                        },
                        color: Colors.grey.withOpacity(0.8),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class EditableCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final VoidCallback onPressed;

  const EditableCircleAvatar(
      {super.key,
      required this.imageUrl,
      required this.size,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(imageUrl),
            radius: size / 2,
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black),
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class ItemProfile extends StatelessWidget {
  const ItemProfile(
      {Key? key,
      required this.leftIcon,
      required this.label,
      required this.onPress,
      this.color})
      : super(key: key);
  final IconData leftIcon;
  final String label;
  final Function onPress;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(leftIcon, size: 28),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        // height: 1.5,
        thickness: 1.5,
        color: Colors.black.withOpacity(0.1),
      ),
    );
  }
}
