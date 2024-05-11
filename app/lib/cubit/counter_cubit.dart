import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

@injectable
class CounterCubit extends Cubit<CounterState> {
  AuthenticatedServiceClient client;
  CounterCubit(this.client) : super(CounterValue(0));

  void increment() async {
    final response = await client.increment(IncrementRequest.create());
    emit(CounterValue(response.value));
  }
}
