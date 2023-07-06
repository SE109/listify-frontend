part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class ButtonLoginPressed extends LoginEvent {
  const ButtonLoginPressed({required this.email, required this.password});
  final String email;
  final String password;
  @override
  List<Object> get props => [email, password];
}

class ButtonLogoutPressed extends LoginEvent {
  const ButtonLogoutPressed();
  @override
  List<Object> get props => [];
}