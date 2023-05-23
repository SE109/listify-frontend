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
  const UpdateInfo({required this.firstName, required this.lastName, required this.phoneNum, required this.dateOfBirth, required this.file, required this.id, required this.context});
  final String firstName; 
  final String lastName; 
  final String phoneNum;
  final DateTime dateOfBirth;
  final File? file;
  final String id;
  final BuildContext context;
  @override
  List<Object> get props => [firstName, lastName, phoneNum, dateOfBirth, file!, context];
}

class UpdateInfoWithoutAvatar extends UserEvent {
  const UpdateInfoWithoutAvatar({required this.firstName, required this.lastName, required this.phoneNum, required this.dateOfBirth, required this.linkAvatar, required this.id, required this.context});
  final String firstName; 
  final String lastName; 
  final String phoneNum;
  final DateTime dateOfBirth;
  final String linkAvatar;
  final String id;
  final BuildContext context;
  @override
  List<Object> get props => [firstName, lastName, phoneNum, dateOfBirth, linkAvatar, context];
}


class ChangePassword extends UserEvent {
  const ChangePassword({required this.oldPassword, required this.newPassword});
  final String oldPassword;
  final String newPassword;
  @override
  List<Object> get props => [];
}

