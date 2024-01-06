import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishr/decorations.dart';
import 'package:wishr/router.gr.dart';

import 'auth_settings.dart';

@RoutePage()
class LoginWrapperPage extends StatelessWidget {
  const LoginWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthCancelledAction((context) {
          print("this happened");
        }),
        ForgotPasswordAction((context, email) {
          AutoRouter.of(context).push(ForgotPasswordRoute());
        }),
        AuthStateChangeAction((context, state) {
          final user = switch (state) {
            SignedIn(user: final user) => user,
            CredentialLinked(user: final user) => user,
            UserCreated(credential: final cred) => cred.user,
            _ => null,
          };

          switch (user) {
            case User(emailVerified: false, email: final String _):
              AutoRouter.of(context).pushNamed('verify');
          }
        }),
        mfaAction,
      ],
      styles: const {
        EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
      },
      headerBuilder: headerImage('assets/images/flutterfire_logo.png'),
      sideBuilder: sideImage('assets/images/flutterfire_logo.png'),
      subtitleBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'Please sign in to continue.',
          AuthAction.signUp => 'Please create an account to continue',
          _ => throw Exception('Invalid action: $action'),
        };

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Welcome to Firebase UI! $actionText.'),
        );
      },
      footerBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'signing in',
          AuthAction.signUp => 'registering',
          _ => throw Exception('Invalid action: $action'),
        };

        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'By $actionText, you agree to our terms and conditions.',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

@RoutePage()
class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(
      headerBuilder: headerIcon(Icons.verified),
      sideBuilder: sideIcon(Icons.verified),
      actionCodeSettings: actionCodeSettings,
      actions: [
        AuthCancelledAction((context) {
          FirebaseUIAuth.signOut(context: context);
          // TODO: Is this right?
          AutoRouter.of(context).pop();
        }),
      ],
    );
  }
}

@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  final String? email;
  const ForgotPasswordPage({this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
      email: email,
      headerMaxExtent: 200,
      headerBuilder: headerIcon(Icons.lock),
      sideBuilder: sideIcon(Icons.lock),
    );
  }
}
