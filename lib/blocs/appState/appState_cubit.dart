
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'appState_state.dart';

class AppStateCubit extends Cubit<AppStateState> {
  AppStateCubit() : super(AppStateInitial());
  
  String  _theme = 'light';
  String get theme => _theme;

  Future<void> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeString = prefs.getString('theme') ?? 'light';
    changeTheme(themeString);
  }

  void changeTheme(value ) async {
    _theme = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme' , value);
    emit(ThemeChanged());
  }

  

}
