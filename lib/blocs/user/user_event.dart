part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetInfo extends UserEvent {
  const GetInfo();

  @override
  List<Object> get props => [];
}

class UpdateInfo extends UserEvent {
  const UpdateInfo({required this.firstName, required this.lastName, required this.phoneNum, required this.dateOfBirth, required this.imgAva});
  final String firstName; 
  final String lastName; 
  final String phoneNum;
  final DateTime dateOfBirth;
  final String imgAva;
  @override
  List<Object> get props => [];
}

class ChangePassword extends UserEvent {
  const ChangePassword({required this.oldPassword, required this.newPassword});
  final String oldPassword;
  final String newPassword;
  @override
  List<Object> get props => [];
}

