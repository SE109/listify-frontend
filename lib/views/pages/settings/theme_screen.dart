

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/appState/appState_cubit.dart';



class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});
  final List<String> themeOptions = [
    'light',
    'dark',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Theme'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (_, index) => ThemeItem(
              title: themeOptions[index],
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeItem extends StatelessWidget {
  const ThemeItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    
    final themeCubit = BlocProvider.of<AppStateCubit>(context, listen: false);
    return Card(
      child: InkWell(
        onTap: () {
          themeCubit.changeTheme(title);
        },
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title.replaceRange(0, 1, title[0].toUpperCase()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                title == themeCubit.theme
                    ? const Icon(Icons.check_rounded)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
