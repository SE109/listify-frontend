import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';


class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {super.key,
      this.textEditingController,
      this.textInputType,
      this.label,
      this.validate,
      this.obscureText,
      this.suffixIcon,
      this.enabled,
      this.readOnly,
      this.prefixIcon,
     });
  TextEditingController? textEditingController;
  Function(String?)? validate;
  TextInputType? textInputType;
  String? label;
  bool? obscureText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? readOnly;
  bool? enabled;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isHiddenPassword = false;
  bool readOnly=false;
  @override
  void initState() {
    isHiddenPassword = widget.obscureText??false;
    readOnly=widget.readOnly??false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                    validator: widget.validate!=null?(text) => widget.validate!(text):null,
                    controller: widget.textEditingController,
                    obscureText: isHiddenPassword,
                    readOnly: readOnly,
                    enabled: widget.enabled,
                    obscuringCharacter: '●',
                    keyboardType: widget.textInputType,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      
                        label: Text(widget.label!),
                        hintStyle: TextStyle(color: AppConstants.grey, fontSize: 16, fontWeight: FontWeight.w400),
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: widget.obscureText == true
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    isHiddenPassword = !isHiddenPassword;
                                  });
                                },
                                child: Icon(
                                  isHiddenPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              )
                            : widget.suffixIcon,
                        errorStyle: TextStyle(fontSize: 14)),
                  );
  }
}
