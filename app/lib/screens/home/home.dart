import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishr/bloc/auth_bloc.dart';
import 'package:wishr/src/theme.g.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wishr',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Welcome in"),
              FilledButton(
                  onPressed: () =>
                      BlocProvider.of<AuthBloc>(context).add(LogOutEvent()),
                  child: const Text('Log out'))
            ],
          ),
        ),
      ),
    );
  }
}
