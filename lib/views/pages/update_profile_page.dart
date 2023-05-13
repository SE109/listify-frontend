import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listify/constants/app_constants.dart';
import 'package:listify/models/user.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';


class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key,});
  // final User user;
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

const List<String> gender = <String>['Male', 'Female'];

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String dropdownValue = gender.first;
  File? _file;
  final _fullNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final storage = FirebaseStorage.instance.ref();
  // final id = FirebaseAuth.instance.currentUser!.uid;
  // final firestore = FirebaseFirestore.instance;
  String dateOfbirth="Date Of Birth";
  String? _selectedGender="Male";
  @override
  void initState() {
    // _fullNameController.text=widget.user.fullName!;
    // _addressController.text=widget.customUser.address!;
    // _emailController.text=widget.customUser.email!;
    // _phoneController.text=widget.customUser.phone!;
    // dateOfbirth=widget.customUser.dateOfBirth!;
    // _selectedGender=widget.customUser.gender!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                                ? NetworkImage("https://toigingiuvedep.vn/wp-content/uploads/2021/01/avatar-dep-cute.jpg")
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
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ))
                      ],
                    ),
                    CustomTextFormField(
                      prefixIcon: Icon(Icons.person),
                      label: "First Name",
                      textEditingController: _fullNameController,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                     CustomTextFormField(
                      prefixIcon: Icon(Icons.person),
                      label: "Last Name",
                      textEditingController: _fullNameController,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    CustomTextFormField(
                      prefixIcon: Icon(Icons.email),
                      label: "Email",
                      textInputType: TextInputType.emailAddress,
                      readOnly: false,
                      textEditingController: _emailController,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return "Invalid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
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
                    SizedBox(height: 20,),
                    CustomTextFormField(
                      label: "Date of Birth",
                      prefixIcon: Icon(Icons.calendar_month),
                      textEditingController: _dateOfBirthController,
                      enabled: true,
                      readOnly: true,
                    ),
                    SizedBox(height: 10,),
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
                          _submit();
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
                  const Text("Chọn ảnh hồ sơ của bạn",),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "Chụp ảnh",
                    onPressed: _getImageCamera,
                  ),
                  SizedBox(height: 15,),
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

  Future _getDateOfBirth() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        dateOfbirth = '${date.day}/${date.month}/${date.year}';
      });
      _dateOfBirthController.text=dateOfbirth;
    }
  }

  Future _submit() async {
    if(_file!=null){
  //     try {
  //     final task = await storage.child("$id.jpg").putFile(_file!);
  //     final linkImage = await task.ref.getDownloadURL();
  //     await firestore.collection('User').doc(id).update({
  //         "dateOfBirth": dateOfbirth,
  //         "email": _emailController.text.trim(),
  //         "fullName": _fullNameController.text.trim(),
  //         "gender": _selectedGender,
  //         "image": linkImage,
  //         "address": _addressController.text.trim(),
  //         "phone": _phoneController.text
  //     });
  //     await FirebaseAuth.instance.currentUser!.updatePhotoURL(linkImage);
  //     await FirebaseAuth.instance.currentUser!.updateDisplayName(_fullNameController.text.trim());
  //     await FirebaseAuth.instance.currentUser!.updateEmail(_emailController.text.trim());
  //     await ChatUtil.client.updateUser(ChatUtil.client.state.currentUser!.copyWith(
  //   extraData: {
  //     'name': _fullNameController.text.trim().toString(),
  //     'image': linkImage,
  //   },
  // ),);
  //     BlocProvider.of<UserBloc>(context).add(LoadUser());
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   }
  //   else{
  //     await firestore.collection('User').doc(id).update({
  //         "dateOfBirth": dateOfbirth,
  //         "email": _emailController.text.trim(),
  //         "fullName": _fullNameController.text.trim(),
  //         "gender": _selectedGender,
  //         "address": _addressController.text.trim(),
  //         "phone": _phoneController.text
  //     });
  //     await FirebaseAuth.instance.currentUser!.updateDisplayName(_fullNameController.text.trim());
  //     await FirebaseAuth.instance.currentUser!.updateEmail(_emailController.text.trim());
  //     await ChatUtil.client.updateUser(ChatUtil.client.state.currentUser!.copyWith(
  //   extraData: {
  //     'name': _fullNameController.text.trim().toString(),
  //   },
  // ),);
    }
    
  }
  Widget GenderSelection(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Giới tính",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: AppConstants.grey),),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Nam",style: TextStyle(fontSize: 16)),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedGender="Male";
                });
              },
              child: Icon(_selectedGender=="Male"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Male"?AppConstants.blue:AppConstants.grey ,),
            ),
            SizedBox(width: 20,),
            Text("Nữ",style: TextStyle(fontSize: 16),),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedGender="Female";
                });
              },
              child: Icon(_selectedGender=="Female"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Female"?AppConstants.blue:AppConstants.grey ,),
            ),
            SizedBox(width: 20,),
            Text("Khác",style: TextStyle(fontSize: 16),),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedGender="Other";
                });
              },
              child: Icon(_selectedGender=="Other"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Other"?AppConstants.blue:AppConstants.grey ,),
            ),
          ],
        ),
      ],
    );
  }
}

// class GenderSelection extends StatefulWidget {
//   GenderSelection({super.key,required this.selectedGender});

//   @override
//   _GenderSelectionState createState() => _GenderSelectionState();
//   String selectedGender;
// }

// class _GenderSelectionState extends State<GenderSelection> {
//   String? _selectedGender="Male";

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Gender",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
//           SizedBox(height: 10,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text("Male",style: TextStyle(color: Colors.white,fontSize: 16)),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _selectedGender="Male";
//                   });
//                 },
//                 child: Icon(_selectedGender=="Male"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Male"?CustomColor.green:Colors.white ,),
//               ),
//               SizedBox(width: 20,),
//               Text("Female",style: TextStyle(color: Colors.white,fontSize: 16),),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _selectedGender="Female";
//                   });
//                 },
//                 child: Icon(_selectedGender=="Female"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Female"?CustomColor.green:Colors.white ,),
//               ),
//               SizedBox(width: 20,),
//               Text("Other",style: TextStyle(color: Colors.white,fontSize: 16),),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _selectedGender="Other";
//                   });
//                 },
//                 child: Icon(_selectedGender=="Other"?Icons.radio_button_checked:Icons.radio_button_unchecked,color:_selectedGender=="Other"?CustomColor.green:Colors.white ,),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }