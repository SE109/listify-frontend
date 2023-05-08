

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context , listen: false);
    return  Scaffold(
      body: Center(child: InkWell(
        onTap: () {
          theme.changeTheme('dark' );
        },
        child: const Text("Home Page")),),
    );
  }
}