import 'package:app/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'src/injection.dart';
import 'firebase_options.dart';

void main() async {
  configureInjection(kDebugMode ? Environment.dev : Environment.prod);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator("192.168.86.195", 9099);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fWish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: const AuthFlow(),
      ),
    );
  }
}

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AuthSuccess) {
            return const Center(child: Text("Welcome in"));
          }

          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hello, please sign in"),
                EmailAndPassword(),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is AuthFailure) {
            final snack = SnackBar(content: Text(state.errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
        },
      ),
    );
  }
}

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
        children: [
          const Text("Email address"),
          TextFormField(
            controller: emailController,
          ),
          const Text("Password"),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            onFieldSubmitted: (value) => _signUp(context),
          )
        ],
      ),
    );
  }

  void _signUp(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(SignUpEvent(
        emailController.text.trim(), passwordController.text.trim()));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
