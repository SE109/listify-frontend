import 'package:flutter/material.dart';
import 'package:listify/constants/app_constants.dart';
import 'package:listify/routes/app_routes.dart';
import 'package:listify/views/widgets/custom_button.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/otp.png",
          scale: 2,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "OTP Vetification",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: RichText(
            text: TextSpan(
              text: 'Enter the OTP sent to ',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w500),
              children: const <TextSpan>[
                TextSpan(
                    text: 'tuankhoi2302@gmail.com',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OTPTextField(
            otpFieldStyle: OtpFieldStyle(
                backgroundColor: AppConstants.grey.withOpacity(0.3),
                // disabledBorderColor: AppConstants.grey.withOpacity(0.3)
                borderColor: AppConstants.grey.withOpacity(0.3),
                enabledBorderColor: AppConstants.grey.withOpacity(0.3)),
            length: 4,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 70,
            style: TextStyle(fontSize: 17),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              Navigator.pushNamed(context, AppRoutes.newPassPage);
            },
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: RichText(
            text: TextSpan(
              text: "Don't receive the OTP? ",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w500),
              children: const <TextSpan>[
                TextSpan(
                    text: 'RESEND OTP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppConstants.blue)),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
