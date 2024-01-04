import 'dart:async';

import 'package:api/api.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import 'test_injections.config.dart';

final getIt = GetIt.instance;

@InjectableInit(generateForDir: ['test'], preferRelativeImports: true)
void configureInjection() => getIt.init();

class MockResponseFuture<T> extends Mock implements ResponseFuture<T> {
  final T value;
  final Duration? delayed;

  MockResponseFuture(this.value, {this.delayed});

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) {
    if (delayed != null) {
      return Future.delayed(delayed!, () => value)
          .then(onValue, onError: onError);
    }
    return Future.value(value).then(onValue, onError: onError);
  }
}

@Injectable(as: IncrementServiceClient)
class MockIncrementClient extends Mock implements IncrementServiceClient {
  @override
  ResponseFuture<IncrementResponse> increment(IncrementRequest request,
      {CallOptions? options}) {
    return MockResponseFuture(
      IncrementResponse(value: 1),
      delayed: const Duration(milliseconds: 100),
    );
  }
}
