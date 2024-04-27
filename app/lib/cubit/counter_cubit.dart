import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  AuthenticatedServiceClient client;
  CounterCubit(this.client) : super(CounterValue(0));

  void increment() async {
    final response = await client.increment(
      IncrementRequest.create(),
      options: CallOptions(
        metadata: {
          'auth': await FirebaseAuth.instance.currentUser?.getIdToken() ?? ''
        },
      ),
    );
    emit(CounterValue(response.value));
  }
}
