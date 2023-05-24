
import 'package:flutter/material.dart';

import 'settings_item.dart';
import 'theme_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SettingsItem(
                title: 'Theme',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ThemeScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
