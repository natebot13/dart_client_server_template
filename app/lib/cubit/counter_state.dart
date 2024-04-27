part of 'counter_cubit.dart';

@immutable
sealed class CounterState {}

final class CounterValue extends CounterState {
  final int value;
  CounterValue(this.value);
}
