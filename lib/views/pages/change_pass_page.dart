import 'package:flutter/material.dart';
import 'package:listify/constants/app_constants.dart';
import 'package:listify/repositories/user_repository.dart';
import 'package:listify/views/widgets/custom_app_bar.dart';

import '../widgets/custom_textfield.dart';



class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bg,
      appBar: CustomAppBar(title: "",),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Image.asset("assets/images/update_pass.png",scale: 3,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Change",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password",
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Please enter the old password and new password for your account.",
                      style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextFormField(
                                          prefixIcon: Icon(Icons.lock),
                                          label: "Old Password",
                                          obscureText: true,
                                          textEditingController:
                                              _oldPassController,
                                          validate: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 8) {
                                              return "Password at least 8 characters";
                                            }
                                          },
                                          textInputType: TextInputType.text,
                                        ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextFormField(
                                            prefixIcon: Icon(Icons.lock),
                                            label: "New Password",
                                            obscureText: true,
                                            textEditingController:
                                                _newPassController,
                                            validate: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 8) {
                                                return "Password at least 8 characters";
                                              }
                                            },
                                            textInputType: TextInputType.text,
                                          ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
              ),
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await UserRepository().changePassword(_oldPassController.text.trim(), _newPassController.text.trim());
                    print(response.toString());
                  }
                },
                child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppConstants.blue),
                            child: const Center(
                                child: Text("Change Password",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
          ]),
        ),
      ),
    );
  }
}
