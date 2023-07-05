import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listify/config/app_config.dart';

import '../common/custom_alert_dialog.dart';



class UserRepository{
  static final FlutterSecureStorage storage = const FlutterSecureStorage();
  static final Dio dio = Dio();
  // String? accessToken;
  // UserRepository() {
  //   dio.interceptors
  //       .add(InterceptorsWrapper(
  //     onRequest: (options, handler) async {     
  //     if (!options.path.contains('http')) {
  //       options.path = AppConfig.mainUrl + options.path;
  //     }
  //     options.headers['authorization'] = 'Bearer $accessToken';
  //     return handler.next(options);
  //   }, onError: (DioError error, handler) async {
  //       if ((error.response?.statusCode == 401 &&
  //         error.response?.data['message'] == "jwt expired")) {
  //           print("lỗi ở đây");
  //         await refreshToken();
  //         return handler.resolve(await retry(error.requestOptions));
  //     }
  //     return handler.next(error);
  //   }));}

static void setupInterceptors(String accessToken) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!options.path.contains('http')) {
              options.path = AppConfig.mainUrl + options.path;
          }
          if (accessToken.isNotEmpty) {
            // Đặt AccessToken vào tiêu đề của yêu cầu
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Xử lý phản hồi từ máy chủ nếu cần
          return handler.next(response);
        },
        onError: (DioError error, handler) async {
          // Xử lý lỗi từ máy chủ nếu cần
          if (error.response?.statusCode == 401 &&
           error.response?.data['message'] == "jwt expired") {
            // AccessToken hết hạn, thực hiện các xử lý khác tại đây
            // Ví dụ: Gửi yêu cầu để lấy AccessToken mới và cập nhật lại trong hệ thống
            // Sau đó, thử lại yêu cầu ban đầu
            String? refreshToken = await storage.read(key: 'refreshToken');
            final response = await dio.post('/auth/refresh-token', data: {"refreshToken":refreshToken});
    if (response.statusCode == 200) {
      // successfully got the new access token
      // accessToken = response.data['data']['accessToken'];
      print("jwt co het han");
      await storage.write(key: 'accessToken', value: response.data['data']['accessToken']);
      await storage.write(key: 'refreshToken', value: response.data['data']['refreshToken']);
      setupInterceptors(response.data['data']['accessToken']);
      return handler.resolve(await retry(error.requestOptions));
    } else {
      // refresh token is wrong so log out user.
      // accessToken = null;
      // storage.deleteAll();
    }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> refreshToken() async {
    // final refreshToken = await storage.read(key: 'refreshToken');
    try{
      final response = await dio.post(AppConfig.refreshTokenUrl);
    if (response.statusCode == 200) {
      // successfully got the new access token
      // accessToken = response.data['data']['accessToken'];
      // print(response.data['data']['accessToken']);
    } else {
      // refresh token is wrong so log out user.
      // accessToken = null;
      // storage.deleteAll();
    }
    }on DioError catch(e){
      print(e.response!.data['message']);
    }
  }

  Future<String> getToken() async {
    String? value = await storage.read(key: 'accessToken');
    return value??"";
  }

  Future<bool> hasToken() async {
    String? value = await storage.read(key: 'accessToken');
    return value!=null?true:false;
  }

  Future<void> persisteToken(String accessToken, String refreshToken) async{
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    // accessToken = token;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    await storage.deleteAll();
  }

  Future<Response> login(String email, String password) async {
    final body= {
      'email':email,
      'password':password
    };
    Response response = await dio.post(AppConfig.loginUrl, data: body);
    return response;
  }

  Future<void> logout() async {
    String? refreshToken = await storage.read(key: 'refreshToken');
    // final header ={
    //   'authorization': 'Bearer $token'
    // };
    await dio.delete(AppConfig.logoutUrl, data: {"refreshToken":refreshToken});
  }

  Future<Response> register(String lastName, String firstName, String phone, String email, String password) async {
    // String? token = await storage.read(key: 'token');
    // final header ={
    //   'authorization': 'Bearer $token'
    // };
    final body= {
      "email": email,
      "password": password,
      "lastName": lastName,
      "firstName": firstName,
      "phoneNum": phone
    };
    print(body);
    Response response = await dio.post(AppConfig.registerUrl, data: body);
    return response;
  }

  Future<void> changePassword(BuildContext context, String oldPassword, String newPassword) async {
    // String? token = await storage.read(key: 'token');
    // final header ={
    //   'authorization': 'Bearer $token'
    // };
    final body= {
      'oldPassword':oldPassword,
      'newPassword':newPassword
    };
    try{
      Response response = await dio.put(AppConfig.changePasswordUrl, data: body);
      CustomAlertDialog().showSuccess(context, "Change Password Success", response.data['message']);
    }on DioError catch(e){
      CustomAlertDialog().showError(context, "Change Password Failure", e.response!.data['message']);
    }
     
  }

  Future<Response> getInfo() async {
    // String? token = await storage.read(key: 'token');
    // final header ={
    //   'authorization': 'Bearer $token'
    // };
    Response response = await dio.get(AppConfig.getInfoUrl,);
    return response;
  }

  Future<Response> updateAvatar(File imageAva, String id) async {
    final firebaseStorage = FirebaseStorage.instance.ref();
    final task = await firebaseStorage.child("$id.jpg").putFile(imageAva);
    final linkImage = await task.ref.getDownloadURL();
    String? token = await storage.read(key: 'token');
    final header ={
      'authorization': 'Bearer $token'
    };
    final body= {
      'avatar':linkImage,
    };
    Response response = await dio.put(AppConfig.updateAvatarUrl, options: Options(headers: header), data: body);
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
      "dateOfBirth": dateOfBirth.toUtc().toString()
    };
    Response response = await dio.put(AppConfig.updateInfoUrl, options: Options(headers: header), data: body);
    return response;
  }
}