part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  const UserLoaded({required this.user});
  final User user;
  @override
  List<Object> get props => [user];
}

class UserSuccess extends UserState {
  const UserSuccess({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

class UserFailure extends UserState {
  const UserFailure({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}