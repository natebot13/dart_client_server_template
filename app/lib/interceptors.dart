import 'package:client_template/config.dart';
import 'package:client_template/src/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';

typedef Executor<R> = ResponseFuture<R> Function(CallOptions options);

_addToken(Map<String, String> metadata, String _) async {
  final token = await FirebaseAuth.instance.currentUser?.getIdToken();
  metadata[getIt.get<ServerConfig>().authHeader] = token ?? '';
}

class AuthInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    return invoker(
      method,
      request,
      options.mergedWith(CallOptions(providers: [_addToken])),
    );
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return invoker(
      method,
      requests,
      options.mergedWith(CallOptions(providers: [_addToken])),
    );
  }
}
