part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  const LoggedIn({required this.token});
  final String token;

  @override
  List<Object> get props => [token];

  @override
  String toString() {
    return 'LoggedIn {$token}';
  }
}

class LoggedOut extends AuthEvent {}