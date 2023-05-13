import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';


class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.onPressed, required this.text, this.color, this.isDisable = false});
  String? text;
  Function()? onPressed;
  Color? color;
  bool isDisable;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor:color ?? AppConstants.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: isDisable ? null : onPressed,
        child: Text(
          text!,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ));
  }
}
