import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:listify/repositories/user_repository.dart';

import '../../models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetInfo>((event, emit) async {
      emit(UserLoading());
      final Response userResponse = await UserRepository().getInfo();
      final User user = User.fromJson(jsonDecode(userResponse.body));
      emit(UserLoaded(user: user));
    });
    on<UpdateInfo>((event, emit) async {
      emit(UserLoading());
      // final state = this.state as UserLoaded;
      // final mail= state.user.mail;
      // final newInfoUser = User(mail: mail, firstName: event.firstName, lastName: event.lastName, avatar: event.imgAva, phoneNum: event.phoneNum, dateOfBirth: event.dateOfBirth);
      try{
        final response = await UserRepository().updateAvatar(event.imgAva);
        final json =jsonDecode(response.body);
        if(response.statusCode==200){
          emit(UserSuccess(message: json['message']));
        }
        else{
          emit(UserFailure(error: json['message']));
        }
      }catch(e){
        emit(UserFailure(error: e.toString()));
      }
      try{
        final response = await UserRepository().updateInfo(event.firstName, event.lastName, event.phoneNum, event.dateOfBirth);
        final json =jsonDecode(response.body);
        if(response.statusCode==200){
          emit(UserSuccess(message: json['message']));
        }
        else{
          emit(UserFailure(error: json['message']));
        }
      }catch(e){
        emit(UserFailure(error: e.toString()));
      }
    });
  }
}
