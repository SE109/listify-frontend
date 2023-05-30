import 'package:flutter/material.dart';
import 'package:listify/repositories/user_repository.dart';
import 'package:listify/views/widgets/rename_screen.dart';


import '../models/user.dart';
import '../views/pages/login_register/forgot_password_page.dart';
import '../views/pages/login_register/new_pass_page.dart';
import '../views/pages/login_register/otp_page.dart';
import '../views/pages/login_register/register_page.dart';
import '../views/pages/user_profile/change_pass_page.dart';
import '../views/pages/user_profile/update_profile_page.dart';

class AppRoutes {
  static const home = '/HomePage';
  static const login = '/LoginPage';
  static const register = '/RegisterPage';
  static const changePassWord = '/ChangePasswordPage';
  static const updateProfile = '/UpdateProfilePage';
  static const forgotPassword = '/ForgotPasswordPage';
  static const otpPage = '/OtpPage';
  static const newPassPage = '/NewPassPage';

  Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.register:{
        final arg = settings.arguments as UserRepository;
        return MaterialPageRoute(builder: (context) => RegisterPage(userRepository: arg,),settings: settings);
      }
      case AppRoutes.changePassWord:{
        return MaterialPageRoute(builder: (context) => const ChangePassPage(),settings: settings);
      }
      case AppRoutes.updateProfile:{
        final user = settings.arguments as User;
        return MaterialPageRoute(builder: (context) => UpdateProfilePage(user: user,),settings: settings);
      }
      case AppRoutes.forgotPassword:{
        return MaterialPageRoute(builder: (context) => const ForgotPassPage(),settings: settings);
      }
      case AppRoutes.otpPage:{
        return MaterialPageRoute(builder: (context) => const OtpPage(),settings: settings);
      }
      case AppRoutes.newPassPage:{
        return MaterialPageRoute(builder: (context) => const NewPassPage(),settings: settings);
      }
      
    }
    return null;
  }
}
