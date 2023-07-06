import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:listify/blocs/auth/auth_bloc.dart';
import 'package:listify/repositories/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthBloc authBloc;
  LoginBloc({required this.userRepository, required this.authBloc}) : super(LoginInitial()) {
    on<ButtonLoginPressed>((event, emit) async {
      emit(LoginLoading());
      try{
        final response = await userRepository.login(event.email, event.password);
        final accessToken = response.data['data']['accessToken'].toString();
        final refreshToken = response.data['data']['refreshToken'].toString();
        // print(token);
        UserRepository.setupInterceptors(accessToken);
        authBloc.add(LoggedIn(accessToken: accessToken, refreshToken: refreshToken));
        emit(LoginInitial());
      }on DioError catch(e){
        emit(LoginFailure(e.response!.data['message']));
      }  
    });
    on<ButtonLogoutPressed>((event, emit) async {
      emit(LoginLoading());
      userRepository.deleteToken();
      authBloc.add(LoggedOut());
      emit(LoginInitial());
    });
  }
}
