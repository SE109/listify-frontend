part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class ButtonRegisterPressed extends RegisterEvent {
  const ButtonRegisterPressed({required this.lastName, required this.firstName, required this.phone, required this.email, required this.password, required this.clear, });
  final String lastName;
  final String firstName;
  final String phone;
  final String email;
  final String password;
  final Function() clear;
  @override
  List<Object> get props => [lastName, firstName, phone, email, password, clear];
}