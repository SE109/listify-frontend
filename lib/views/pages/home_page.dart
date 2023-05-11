import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/blocs/auth/auth_bloc.dart';
import 'package:listify/repositories/user_repository.dart';

import '../../blocs/login/login_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userRepository,});
  final UserRepository userRepository;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
          authBloc: BlocProvider.of<AuthBloc>(context),
          userRepository: widget.userRepository),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                child: Text("Logout"),
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context)
                      .add(ButtonLogoutPressed());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
