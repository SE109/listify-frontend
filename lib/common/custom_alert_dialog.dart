import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog{
  void showSuccess(BuildContext context, String title, String desc){
    AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: title,
            desc: desc,
            btnOkOnPress: () {
              
            },
            )..show();
  }
  void showError(BuildContext context, String title, String desc){
    AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: title,
            desc: desc,
            btnCancelOnPress: () {
              
            },
            )..show();
  }
}