import 'dart:async';

import 'package:api/api.dart';
import 'package:grpc/grpc.dart' hide Service;
import 'package:logging/logging.dart';
import 'package:server/config.dart';
import 'package:server/injection.dart';

import 'firebase_auth_token/public_key/service.dart';
import 'firebase_auth_token/firebase_auth_token.dart';
import 'firebase_auth_token/public_key/repository.dart';

class MethodContext {
  final ServiceCall _call;
  String? get uid => _call.clientMetadata?['uid'];

  MethodContext.fromCall(this._call);
}

class AuthenticatedService extends AuthenticatedServiceBase {
  static final Logger logger = Logger("AuthenticatedService");
  int _counter = 0;

  @override
  Future<IncrementResponse> increment(
    ServiceCall call,
    IncrementRequest request,
  ) async {
    final context = MethodContext.fromCall(call);
    logger.info(context.uid);
    return IncrementResponse(value: ++_counter);
  }
}

class UnauthenticatedService extends UnauthenticatedServiceBase {}

class GameServer {
  static final Logger logger = Logger("GameServer");
  final Server _server;
  GameServer._(this._server);

  static final publicKeyService = Service(Repository());

  static FutureOr<GrpcError?> _authenticationInterceptor(
    ServiceCall call,
    ServiceMethod method,
  ) async {
    final serverConfig = getIt.get<ServerConfig>();
    logger.info(method.name);
    final metadata = call.clientMetadata ?? {};
    final idToken = metadata[serverConfig.authHeader];
    if (idToken == null) {
      return GrpcError.unauthenticated('Missing auth token');
    }

    final token = await FirebaseAuthToken.fromTokenString(
      service: publicKeyService,
      projectId: serverConfig.firebaseProject,
      token: idToken,
    );

    if (serverConfig is DevServerConfig) {
      // Skip verification
    } else if (serverConfig is ProdServerConfig) {
      try {
        await token.verify();
      } on Exception catch (e) {
        return GrpcError.unauthenticated(e.toString());
      }
    }

    // TODO: Build a serializable context object to pass more data
    call.clientMetadata?['uid'] = token.subject ?? '';
    return null;
  }

  static Future<GameServer> start() async {
    final serverConfig = getIt.get<ServerConfig>();
    final server = Server.create(services: [
      AuthenticatedService(),
      UnauthenticatedService(),
    ], interceptors: [
      _authenticationInterceptor
    ]);
    await server.serve(port: serverConfig.port);
    logger.info("Server started on port: ${serverConfig.port}");
    return GameServer._(server);
  }

  Future<void> stop() {
    return _server.shutdown();
  }
}
