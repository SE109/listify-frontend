import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';


class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {super.key,
      this.title,
      this.textEditingController,
      this.textInputType,
      this.hint,
      this.validate,
      this.obscureText,
      this.suffixIcon,
      this.enabled,
      this.readOnly,
      this.maxLength,
      this.height,
      this.minLines,
      this.maxLines});
  String? title;
  TextEditingController? textEditingController;
  Function(String?)? validate;
  TextInputType? textInputType;
  String? hint;
  bool? obscureText;
  Widget? suffixIcon;
  bool? readOnly;
  bool? enabled;
  int? maxLength;
  double? height;
  int? minLines;
  int? maxLines;
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
    return Container(
      height: widget.height==null? 70:70+widget.height!,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppConstants.blue1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text(
                        widget.title!,
                        style: TextStyle(
               fontSize: 14, fontWeight: FontWeight.bold,color: AppConstants.grey),
                      ),
            Container(
              height: widget.height??40,
              child: TextFormField(
                validator: widget.validate!=null?(text) => widget.validate!(text):null,
                minLines: widget.minLines??1,
                maxLines: widget.maxLines??1,
                controller: widget.textEditingController,
                obscureText: isHiddenPassword,
                readOnly: readOnly,
                maxLength: widget.maxLength,
                enabled: widget.enabled,
                obscuringCharacter: '●',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: AppConstants.grey, fontSize: 16, fontWeight: FontWeight.w400),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
