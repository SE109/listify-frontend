import 'package:flutter/material.dart';
import 'package:listify/views/pages/home_page.dart';
import 'package:listify/views/pages/login_page.dart';
import 'package:listify/views/pages/register_page.dart';

class AppRoutes {
  static const home = '/HomePage';
  static const login = '/LoginPage';
  static const register = '/RegisterPage';

  Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:{
        return MaterialPageRoute(builder: (context) => HomePage(),settings: settings);
      }
      case AppRoutes.login:{
        return MaterialPageRoute(builder: (context) => LoginPage(),settings: settings);
      }
      case AppRoutes.register:{
        return MaterialPageRoute(builder: (context) => RegisterPage(),settings: settings);
      }
    }
    return null;
  }
}
