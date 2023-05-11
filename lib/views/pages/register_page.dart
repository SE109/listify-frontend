import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listify/constants/app_constants.dart';
import 'package:listify/repositories/user_repository.dart';

import '../../blocs/register/register_bloc.dart';
import '../../common/custom_toast.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.userRepository});
  final UserRepository userRepository;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();

  void clear (){
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passController.clear();
    _phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => RegisterBloc(userRepository: widget.userRepository),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if(state is RegisterFailure){
            CustomToast().show(message: state.error, color: Colors.red);
          }
          else if (state is RegisterSuccess){
            CustomToast().show(message: state.message, color: Colors.green);
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return Scaffold(
                backgroundColor: AppConstants.bg,
                body: SingleChildScrollView(
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
                                height: 170,
                                width: 170,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 170,
                                              child: CustomTextFormField(
                                                hint: "First Name",
                                                title: "First Name",
                                                obscureText: false,
                                                textEditingController:
                                                    _firstNameController,
                                                validate: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Required";
                                                  }
                                                  return null;
                                                },
                                                textInputType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 170,
                                              child: CustomTextFormField(
                                                hint: "Last Name",
                                                title: "Last Name",
                                                obscureText: false,
                                                textEditingController:
                                                    _lastNameController,
                                                validate: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Required";
                                                  }
                                                  return null;
                                                },
                                                textInputType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CustomTextFormField(
                                          hint: "Phone",
                                          title: "Phone",
                                          obscureText: false,
                                          textEditingController:
                                              _phoneController,
                                          validate: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Invalid email";
                                            }
                                            return null;
                                          },
                                          textInputType: TextInputType.phone,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CustomTextFormField(
                                          hint: "Email",
                                          title: "Email",
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
                                          height: 15,
                                        ),
                                        CustomTextFormField(
                                          hint: "Password",
                                          title: "Password",
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
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<RegisterBloc>(context).add(
                                        ButtonRegisterPressed(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passController.text.trim(),
                                            firstName: _firstNameController.text
                                                .trim(),
                                            lastName:
                                                _lastNameController.text.trim(),
                                            phone:
                                                _phoneController.text.trim(),
                                            clear: clear));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppConstants.blue),
                                    child: const Center(
                                        child: Text("Sign Up",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                      color: AppConstants.blue,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
