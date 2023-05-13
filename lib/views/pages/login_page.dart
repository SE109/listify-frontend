import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listify/blocs/auth/auth_bloc.dart';
import 'package:listify/common/custom_toast.dart';
import 'package:listify/repositories/user_repository.dart';

import '../../blocs/login/login_bloc.dart';
import '../../constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.userRepository});
  final UserRepository userRepository;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHiddenPassword = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validateEmail = true;
  bool validatePass = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoginBloc(
          authBloc: BlocProvider.of<AuthBloc>(context),
          userRepository: widget.userRepository),
      child: Scaffold(
          backgroundColor: AppConstants.bg,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                CustomToast().show(message: state.error, color: Colors.red);
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    height: size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/logo_2.png",
                                height: 180,
                                width: 180,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        CustomTextFormField(
                                          prefixIcon: Icon(Icons.email),
                                          label: "Email",
                                          obscureText: false,
                                          textEditingController:
                                              _emailController,
                                          validate: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(value)) {
                                              return "Invalid email";
                                            }
                                            return null;
                                          },
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CustomTextFormField(
                                          prefixIcon: Icon(Icons.lock),
                                          label: "Password",
                                          obscureText: true,
                                          textEditingController:
                                              _passController,
                                          validate: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 8) {
                                              return "Password at least 8 characters";
                                            }
                                          },
                                          textInputType: TextInputType.text,
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //     context, AppRoutes.forgot);
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Forgot the password?",
                                      style: TextStyle(
                                          color: AppConstants.blue,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<LoginBloc>(context).add(
                                          ButtonLoginPressed(
                                              email:
                                                  _emailController.text.trim(),
                                              password:
                                                  _passController.text.trim()));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppConstants.blue),
                                      child: const Center(
                                          child: Text("Sign In",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white))),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.register,
                                        arguments: widget.userRepository);
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: AppConstants.blue,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
