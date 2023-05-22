import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/auth/auth_bloc.dart';
import 'package:listify/blocs/login/login_bloc.dart';
import 'package:listify/constants/app_constants.dart';

import '../../../blocs/user/user_bloc.dart';
import '../../../routes/app_routes.dart';



class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    state.user.firstName + " " + state.user.lastName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(state.user.phoneNum,
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.6))),
                  SizedBox(
                    height: 50,
                  ),
                  ItemProfile(
                      leftIcon: Icons.lock,
                      label: "Change Password",
                      onPress: () {
                        Navigator.pushNamed(context, AppRoutes.changePassWord);
                      }),
                  CustomDivider(),
                  ItemProfile(
                      leftIcon: Icons.edit,
                      label: "Theme Setting",
                      onPress: () {}),
                  CustomDivider(),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return ItemProfile(
                        leftIcon: Icons.logout,
                        label: "Log Out",
                        onPress: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(ButtonLogoutPressed());
                        },
                        color: Colors.grey.withOpacity(0.8),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
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

  EditableCircleAvatar(
      {required this.imageUrl, required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
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
            icon: Icon(
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
                  Icon(leftIcon, size: 28, color: color ?? Colors.black),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: color ?? Colors.black),
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
