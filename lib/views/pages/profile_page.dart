import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/constants/app_constants.dart';

import '../../blocs/user/user_bloc.dart';
import '../../routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UserBloc(),
        child: SafeArea(
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
                  imageUrl:
                      'https://toigingiuvedep.vn/wp-content/uploads/2021/01/avatar-dep-cute.jpg',
                  size: 110,
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Nguyen Tuan Khoi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text("0961742715",
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
                  leftIcon: Icons.edit, label: "Theme Setting", onPress: () {}),
              CustomDivider(),
              ItemProfile(
                  leftIcon: Icons.phone, label: "Contact Us", onPress: () {}),
              CustomDivider(),
              ItemProfile(
                  leftIcon: Icons.support, label: "Support", onPress: () {}),
              CustomDivider(),
              ItemProfile(
                leftIcon: Icons.logout,
                label: "Log Out",
                onPress: () {},
                color: Colors.grey.withOpacity(0.8),
              ),
            ],
          ),
        ),
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
