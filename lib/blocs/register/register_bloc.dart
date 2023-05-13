import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {
    on<ButtonRegisterPressed>((event, emit) async {
      emit(RegisterLoading());
      try{
        final response = await userRepository.register(event.lastName, event.firstName, event.phone, event.email, event.password);
        final json = jsonDecode(response.body);
        if(response.statusCode==201){
          event.clear();
          emit(RegisterSuccess(message: json['message']));
        }
        else{
          emit(RegisterFailure(error: json['message']));
        }
        emit(RegisterInitial());
      }catch(e){
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}
