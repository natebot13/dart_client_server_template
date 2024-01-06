part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class InitAuthEvent extends AuthEvent {
  const InitAuthEvent();
}

final class LogOutEvent extends AuthEvent {}
