import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:listify/config/app_config.dart';



class UserRepository{
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> hasToken() async {
    String? value = await storage.read(key: 'token');
    return value!=null?true:false;
  }

  Future<void> persisteToken(String token) async{
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
    await storage.deleteAll();
  }

  Future<Response> login(String email, String password) async {
    final body= {
      'email':email,
      'password':password
    };
    Response response = await http.post(Uri.parse(AppConfig.loginUrl),body: body);
    return response;
  }

  Future<void> logout() async {
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    await http.delete(Uri.parse(AppConfig.loginUrl),headers: header);
  }

  Future<Response> register(String lastName, String firstName, String phone, String email, String password) async {
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    final body= {
      "email": email,
      "password": password,
      "lastName": lastName,
      "firstName": firstName,
      "phoneNum": phone
    };
    Response response = await http.post(Uri.parse(AppConfig.registerUrl), headers: header, body: body);
    return response;
  }

  Future<Response> changePassword(String oldPassword, String newPassword) async {
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    final body= {
      'oldPassword':oldPassword,
      'newPassword':newPassword
    };
    Response response = await http.put(Uri.parse(AppConfig.changePasswordUrl), headers: header, body: body);
    return response;
  }

  Future<Response> getInfo() async {
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    Response response = await http.get(Uri.parse(AppConfig.changePasswordUrl), headers: header,);
    return response;
  }

  Future<Response> updateAvatar(String imageAva) async {
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    final body= {
      'avatar':imageAva,
    };
    Response response = await http.put(Uri.parse(AppConfig.updateAvatarUrl), headers: header, body: body);
    return response;
  }

  Future<Response> updateInfo(String firstName, String lastName, String phoneNum, DateTime dateOfBirth) async {
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    final body= {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNum": phoneNum,
      "dateOfBirth": dateOfBirth
    };
    Response response = await http.put(Uri.parse(AppConfig.updateInfoUrl), headers: header, body: body);
    return response;
  }
}