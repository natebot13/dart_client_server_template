part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String errorMessage;
  const AuthFailure({required this.errorMessage});
}
