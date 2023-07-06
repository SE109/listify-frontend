part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  const LoggedIn({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;

  @override
  List<Object> get props => [accessToken, refreshToken];

  @override
  String toString() {
    return 'LoggedIn {$accessToken $refreshToken}';
  }
}

class LoggedOut extends AuthEvent {}