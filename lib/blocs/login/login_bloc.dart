import 'dart:convert';

import 'package:bloc/bloc.dart';
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
        final json = jsonDecode(response.body);
        if(response.statusCode==200){
          final token = json['data']['accessToken'].toString();
          print(response.body.toString());
          authBloc.add(LoggedIn(token: token));
        }  
        else{
          print(json['message']);
          emit(LoginFailure(json['message']));
        }  
        emit(LoginInitial());
      }catch(e){
        emit(LoginFailure(e.toString()));
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
