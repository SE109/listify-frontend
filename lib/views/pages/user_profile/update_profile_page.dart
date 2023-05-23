import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:listify/constants/app_constants.dart';
import 'package:listify/models/user.dart';
import 'package:listify/views/widgets/custom_app_bar.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';


class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({
    super.key,
    required this.user,
  });
  final User user;
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

const List<String> gender = <String>['Male', 'Female'];

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String dropdownValue = gender.first;
  File? _file;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  TextEditingController? _dateOfBirthController;
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? dateOfBirth;
  DateTime? dateOfBirth1;
  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _phoneController.text = widget.user.phoneNum;
    dateOfBirth = widget.user.dateOfBirth != null
        ? DateFormat("dd/MM/yyyy").format(widget.user.dateOfBirth!)
        : null;
    dateOfBirth1 = widget.user.dateOfBirth;
  }

  Future _getDateOfBirth() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: dateOfBirth1 ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: AppConstants.blue,
                  ),
            ),
            child: child!);
      },
    );
    if (date == null) {
      return;
    } else {
      setState(() {
        dateOfBirth = '${date.day}/${date.month}/${date.year}';
        dateOfBirth1 = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Update Profile",
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserLoaded) {
            _dateOfBirthController = TextEditingController(text: dateOfBirth);
            return SafeArea(
              child: Container(
                color: AppConstants.bg,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 50,
                                  backgroundImage: _file == null
                                      ? NetworkImage(state.user.avatar)
                                      : Image.file(
                                          _file!,
                                          fit: BoxFit.cover,
                                        ).image,
                                ),
                              ),
                              Positioned(
                                  right: 25,
                                  bottom: 30,
                                  child: InkWell(
                                    onTap: _editAvatar,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: Icon(Icons.edit,
                                            color: Colors.white, size: 20),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ))
                            ],
                          ),
                          CustomTextFormField(
                            prefixIcon: Icon(Icons.person),
                            label: "First Name",
                            textEditingController: _firstNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            prefixIcon: Icon(Icons.person),
                            label: "Last Name",
                            textEditingController: _lastNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            prefixIcon: Icon(Icons.phone),
                            label: "Phone",
                            readOnly: false,
                            textInputType: TextInputType.phone,
                            textEditingController: _phoneController,
                            // maxLength: 10,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              if (!RegExp(r"(84|0[3|5|7|8|9])+([0-9]{8})")
                                  .hasMatch(value)) {
                                return "Invalid Phone";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              _getDateOfBirth();
                            },
                            child: CustomTextFormField(
                              label: "Date of Birth",
                              prefixIcon: Icon(Icons.calendar_month),
                              textEditingController: _dateOfBirthController,
                              enabled: false,
                              readOnly: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 8),
                          //   child: GenderSelection(),
                          // ),
                          // SizedBox(height: 10,),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomButton(
                            text: "Update",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submit(state.user.mail, context,
                                    state.user.avatar);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _editAvatar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: AppConstants.bg,
          height: 230,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      height: 6,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Tải Hình Ảnh",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    "Chọn ảnh hồ sơ của bạn",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Chụp ảnh",
                    onPressed: _getImageCamera,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    text: "Chọn từ thư viện",
                    onPressed: _getImageGallery,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _getImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTempory = File(image.path);
    setState(() {
      _file = imageTempory;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future _getImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTempory = File(image.path);
    setState(() {
      _file = imageTempory;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future _submit(String id, BuildContext context, String linkAvatar) async {
    if (_file != null) {
      BlocProvider.of<UserBloc>(context).add(UpdateInfo(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNum: _phoneController.text.trim(),
          dateOfBirth: dateOfBirth1!,
          id: id,
          file: _file!,
          context: context));
    } else {
      BlocProvider.of<UserBloc>(context).add(UpdateInfoWithoutAvatar(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNum: _phoneController.text.trim(),
          dateOfBirth: dateOfBirth1!,
          id: id,
          linkAvatar: linkAvatar,
          context: context));
    }
    FocusScope.of(context).unfocus();
  }
}