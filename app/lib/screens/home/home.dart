import 'package:auto_route/annotations.dart';
import 'package:client_template/cubit/counter_cubit.dart';
import 'package:client_template/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../src/theme.g.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'client',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: BlocProvider(
        create: (context) => getIt.get<CounterCubit>(),
        child: Scaffold(
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
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () =>
                  BlocProvider.of<CounterCubit>(context).increment(),
              child: BlocBuilder<CounterCubit, CounterState>(
                builder: (context, state) {
                  if (state is CounterValue) {
                    return Text('${state.value}');
                  }
                  return const Text('?');
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
