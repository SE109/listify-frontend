

import 'package:flutter/material.dart';
import 'package:listify/views/pages/home_page.dart';
import 'package:listify/views/pages/settings/setting_screen.dart';

import '../pages/drawer/app_drawer.dart';


class NavigatingPoint extends StatefulWidget {
  const NavigatingPoint({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigatingPoint> createState() => _NavigatingPointState();
}

class _NavigatingPointState extends State<NavigatingPoint> {
  int currentIndex = 0;

  final screens = [
    const HomePage(),
    const SettingScreen(),
  ];

  _changeIndex(index) => setState(() {
        currentIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const AppDrawer(),
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _changeIndex,
        selectedIndex: currentIndex,
        elevation: 2,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}


