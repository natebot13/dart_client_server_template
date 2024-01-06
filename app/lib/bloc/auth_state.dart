part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

final class AuthLoggedIn extends AuthState {
  final User user;
  const AuthLoggedIn({required this.user});
}
