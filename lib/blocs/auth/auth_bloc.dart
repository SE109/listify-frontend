import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listify/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  AuthBloc(this.userRepository) : super(AuthUninitialized()) {
    on<AppStarted>((event, emit) async {
      final bool hasToken = await userRepository.hasToken();
      if(hasToken){
        emit(AuthAuthenticated());
      }
      else{
        emit(AuthUnAuthenticated());
      }
    });
    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());
      await userRepository.persisteToken(event.token);
      emit(AuthAuthenticated());
    });
    on<LoggedOut>((event, emit) async {
      emit(AuthLoading()); 
      await userRepository.logout();
      await userRepository.deleteToken();  
      emit(AuthUnAuthenticated());
    });
  }
}