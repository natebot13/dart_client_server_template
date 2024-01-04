import 'dart:js_interop';

import 'package:app/authentication.dart';
import 'package:app/user.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();

  AuthBloc() : super(const AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        final User? user =
            await authService.signUpUser(event.email, event.password);
        if (user == null) {
          emit(const AuthFailure(errorMessage: "Something went wrong"));
          emit(const AuthInitial());
        } else {
          emit(AuthSuccess(user: user));
        }
      } catch (e) {
        print(e.toString());
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        await authService.signOutUser();
        emit(const AuthInitial());
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
