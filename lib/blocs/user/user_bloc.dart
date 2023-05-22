import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:listify/repositories/user_repository.dart';

import '../../models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetInfo>((event, emit) async {
      emit(UserLoading());
      try{
        final Response userResponse = await UserRepository().getInfo();
        final User user = User.fromJson(userResponse.data['data']);
        emit(UserLoaded(user: user));
      }on DioError catch(e){
        print(e.response!.data['message']);
      }  
    });

    on<UpdateInfo>((event, emit) async{
      final temp = this.state as UserLoaded;
      showDialog(context: event.context, 
                            barrierDismissible: false,
                            builder: (context) {
                              return Center(child: CircularProgressIndicator());    
                            },);
      String? linkImage;
      try{
        final response = await UserRepository().updateAvatar(event.file!, event.id);
      }catch(e){

      }
      try{
        final response = await UserRepository().updateInfo(event.firstName, event.lastName, event.phoneNum, event.dateOfBirth);
        linkImage = response.data['data']['avatar'];
        final newInfoUser = User(mail: temp.user.mail, firstName: event.firstName, lastName: event.lastName, avatar: linkImage!, phoneNum: event.phoneNum, dateOfBirth: event.dateOfBirth);
        emit(UserLoaded(user: newInfoUser));
      }catch(e){
      
      }
      Navigator.pop(event.context);
      
    },);
    on<UpdateInfoWithoutAvatar>((event, emit) async{
      final temp = this.state as UserLoaded;
      showDialog(context: event.context, 
                            barrierDismissible: false,
                            builder: (context) {
                              return Center(child: CircularProgressIndicator());    
                            },);
     
      
      try{
        final response = await UserRepository().updateInfo(event.firstName, event.lastName, event.phoneNum, event.dateOfBirth);
        final newInfoUser = User(mail: temp.user.mail, firstName: event.firstName, lastName: event.lastName, avatar: event.linkAvatar, phoneNum: event.phoneNum, dateOfBirth: event.dateOfBirth);
        emit(UserLoaded(user: newInfoUser));
      }catch(e){
      
      }
      Navigator.pop(event.context);
      
    },);
  }
}
