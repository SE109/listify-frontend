
import 'package:flutter/material.dart';

import 'color_schemes.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    splashFactory: NoSplash.splashFactory,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    splashFactory: NoSplash.splashFactory,
  );
}
