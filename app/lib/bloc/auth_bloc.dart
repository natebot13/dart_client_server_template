import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth authService;

  AuthBloc(this.authService) : super(const AuthLoggedOut()) {
    on<InitAuthEvent>((event, emit) async {
      await emit.forEach(
        authService.authStateChanges(),
        onData: (maybeUser) {
          if (maybeUser != null && maybeUser.emailVerified) {
            return AuthLoggedIn(user: maybeUser);
          }
          return const AuthLoggedOut();
        },
      );
    });

    on<LogOutEvent>((event, emit) async {
      await authService.signOut();
    });

    add(const InitAuthEvent());
  }
}
