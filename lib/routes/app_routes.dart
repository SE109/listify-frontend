import 'package:flutter/material.dart';
import 'package:listify/repositories/user_repository.dart';
import 'package:listify/views/pages/home_page.dart';
import 'package:listify/views/pages/login_page.dart';
import 'package:listify/views/pages/register_page.dart';
import 'package:listify/views/pages/change_pass_page.dart';

class AppRoutes {
  static const home = '/HomePage';
  static const login = '/LoginPage';
  static const register = '/RegisterPage';
  static const changePassWord = '/ChangePasswordPage';

  Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.register:{
        final arg = settings.arguments as UserRepository;
        return MaterialPageRoute(builder: (context) => RegisterPage(userRepository: arg,),settings: settings);
      }
      case AppRoutes.changePassWord:{
        return MaterialPageRoute(builder: (context) => const ChangePassPage(),settings: settings);
      }
    }
    return null;
  }
}
