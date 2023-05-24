part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthLoading extends AuthState {}
